{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.chaotic.nixosModules.default
    ./hardware.nix
    ./disko.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";

  networking.hostName = "testvm";
  networking.hostId = "1a71df94"; # cut -c-8 </proc/sys/kernel/random/uuid

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  boot.zfs.package = config.boot.kernelPackages.zfs_cachyos;

  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  chaotic.zfs-impermanence-on-shutdown = {
    enable = true;
    volume = "zroot/ROOT/empty";
    snapshot = "start";
  };

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
