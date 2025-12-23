{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./disko.nix
    ../../modules/zfs-tpm-unlock.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";

  networking.hostName = "testvm";
  networking.hostId = "1a71df94"; # cut -c-8 </proc/sys/kernel/random/uuid

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = lib.mkOverride 99 pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  boot.zfs.package = lib.mkOverride 99 config.boot.kernelPackages.zfs_cachyos;

  boot.supportedFilesystems = [
    "zfs"
    "vfat"
  ];

  # ZFS TPM unlock configuration
  boot.zfs.tpmUnlock = {
    enable = true;
    dataset = "zroot/data/encrypted";
    pcrIndex = 15;
  };

  # Initrd configuration for TPM unsealing
  boot.initrd = {
    kernelModules = [
      "tpm_tis"
      "tpm_crb"
    ];

    extraUtilsCommands = ''
      copy_bin_and_libs ${pkgs.tpm2-tools}/bin/tpm2_unseal
      copy_bin_and_libs ${pkgs.tpm2-tools}/bin/tpm2_pcrread

      # Copy required libraries
      for lib in ${pkgs.tpm2-tss}/lib/libtss2-*.so*; do
        copy_bin_and_libs $lib
      done
    '';

    postDeviceCommands = ''
      # Wait for ZFS pool to be imported
      echo "ZFS TPM Unlock: Waiting for ZFS pool import..."
      for i in $(seq 1 10); do
        if zpool list zroot >/dev/null 2>&1; then
          break
        fi
        sleep 1
      done

      # Check if encrypted dataset exists
      if zfs list zroot/data/encrypted 2>/dev/null; then
        echo "ZFS TPM Unlock: Attempting to unseal encryption key..."

        # Try to unseal from TPM persistent handle
        if ${pkgs.tpm2-tools}/bin/tpm2_unseal \
             -c 0x81010001 \
             -o /run/zfs-key 2>/dev/null; then
          echo "ZFS TPM Unlock: TPM unseal successful"
          chmod 600 /run/zfs-key
        else
          echo "ZFS TPM Unlock: TPM unseal failed, requesting password..."
          echo -n "Enter ZFS encryption password: "
          read -s password
          echo
          echo -n "$password" > /run/zfs-key
          chmod 600 /run/zfs-key
          unset password
        fi
      else
        echo "ZFS TPM Unlock: Encrypted dataset not found, skipping"
      fi
    '';
  };

  # Don't auto-request credentials (we handle it manually)
  boot.zfs.requestEncryptionCredentials = false;

  # Systemd service to load ZFS key and mount encrypted dataset
  systemd.services.zfs-load-encrypted = {
    description = "Load ZFS encryption key and mount encrypted dataset";
    after = [ "zfs-import.target" ];
    before = [ "local-fs.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash -c 'if ${config.boot.zfs.package}/bin/zfs list zroot/data/encrypted 2>/dev/null; then ${config.boot.zfs.package}/bin/zfs load-key zroot/data/encrypted && ${config.boot.zfs.package}/bin/zfs mount zroot/data/encrypted || true; fi'";
    };
  };

  specialisation.safe.configuration = {
    boot.kernelPackages = lib.mkOverride 98 pkgs.linuxPackages;
    boot.zfs.package = lib.mkOverride 98 pkgs.zfs;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  # inspired https://github.com/chaotic-cx/nyx/blob/aacb796ccd42be1555196c20013b9b674b71df75/modules/nixos/zfs-impermanence-on-shutdown.nix
  systemd.shutdownRamfs.contents."/etc/systemd/system-shutdown/zfs-rollback".source =
    pkgs.writeShellScript "zfs-rollback" ''
      ${config.boot.zfs.package}/bin/zfs rollback -r zroot/ROOT/empty@start
      ${config.boot.zfs.package}/bin/zpool sync
    '';
  systemd.shutdownRamfs.storePaths = [ "${config.boot.zfs.package}/bin/zfs" ];

  users.users.test = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "test"; # INSECURE - for testing only!
  };

  services.zfs.trim.enable = false;

  # TPM2 support
  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;
  security.tpm2.tctiEnvironment.enable = true;

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
    settings.PasswordAuthentication = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    tpm2-tools
  ];

  nix.settings.substituters = [
    "https://cache.garnix.io"
    "https://attic.xuyh0120.win/lantian" # cache for cachyos kernel
  ];
  nix.settings.trusted-public-keys = [
    "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
  ];
}
