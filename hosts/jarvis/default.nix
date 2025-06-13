{ inputs, pkgs, ... }:
{
  imports = [

    inputs.impermanence.nixosModules.impermanence

    ../../config

    ../../config/hardware/mesa.nix
    ../../config/hardware/intel.nix
    ../../config/hardware/ergohaven.nix
    ../../config/hardware/ni-audio-6.nix
    ../../config/graphical  

    ../../users/crookedmirror
  
    ./fs.nix
    ./net.nix
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
  # My preferred kernel
  boot.kernelPackages = lib.mkOverride 99 pkgs.linuxPackages_cachyos;

  # Filesytems settings.
  boot.supportedFilesystems = [ "zfs" "vfat" "ntfs3" ];
  boot.zfs.requestEncryptionCredentials = false;
  boot.zfs.package = lib.mkOverride 99 pkgs.zfs_cachyos;

  # I prefer to trim using ZFS' "autotrim"
  services.zfs.trim.enable = false;

  # ZFS-based impermanence
  chaotic.zfs-impermanence-on-shutdown = {
    enable = true;
    volume = "zroot/ROOT/empty";
    snapshot = "start";
  };

  environment.persistence."/var/persistent" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  users.users."root".hashedPasswordFile = "/var/persistent/secrets/shadow/root";

  environment = {
    systemPackages = with pkgs; [
      vim
      git
      scripts.nvidia-offload
      corectrl
    ];
};
  
}
