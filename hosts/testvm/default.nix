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
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";

  networking.hostName = "testvm";
  networking.hostId = "1a71df94"; # cut -c-8 </proc/sys/kernel/random/uuid

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = lib.mkOverride 99 pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  boot.zfs.package = lib.mkOverride 99 config.boot.kernelPackages.zfs_cachyos;

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

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
    settings.PasswordAuthentication = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  nix.settings.substituters = [
    "https://cache.garnix.io"
    "https://attic.xuyh0120.win/lantian"
  ];
  nix.settings.trusted-public-keys = [
    "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
  ];
}
