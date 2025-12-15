{ inputs, pkgs, ... }:
{
  imports = [
    inputs.chaotic.nixosModules.default
    ./hardware.nix
    ./disko.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "testvm";
  networking.hostId = "12345678"; # Required for ZFS
  system.stateVersion = "25.05";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable impermanence - root resets on shutdown
  chaotic.zfs-impermanence-on-shutdown = {
    enable = true;
    volume = "zroot/ROOT/empty";
    snapshot = "start";
  };

  # Minimal user setup
  users.users.test = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "test"; # INSECURE - for testing only!
  };

  # Allow password auth for testing
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
    settings.PasswordAuthentication = true;
  };

  # Minimal packages
  environment.systemPackages = with pkgs; [
    vim
    git
  ];
}
