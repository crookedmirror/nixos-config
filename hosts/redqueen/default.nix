{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    (import ./disko-config.nix { zpoolName = config.networking.hostName; })
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "redqueen"; # Define your hostname.
  networking.hostId = "e242fab1"; # cut -c-8 </proc/sys/kernel/random/uuid

  services.openssh.openFirewall = false;
  system.stateVersion = "25.05"; # Did you read the comment?
}
