{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware/dellvis.nix
    ../modules
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "intel_iommu=on"
    "nouveau.config=NvGspRm=1"
    "nouveau.debug=\"GSP=debug\""
  ];
  boot.initrd.kernelModules = [ "nouveau" ];
  boot.kernelPackages = lib.mkOverride 99 pkgs.linuxPackages_cachyos;

  environment = {
    systemPackages = with pkgs; [
      vulkan-caps-viewer
      vulkanPackages_latest.vulkan-tools
      vim
      git
      home-manager
      nvidia-offload
    ];

    variables = {
      "VK_DRIVER_FILES" =
        "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/intel_icd.i686.json";
      "LIBVA_DRIVER_NAME" = "iHD";
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };

  chaotic.mesa-git = {
    enable = true;
    fallbackSpecialisation = false;
    extraPackages = with pkgs; [ intel-media-driver ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      nvidia-offload = final.callPackage ./../scripts { scriptName = "nvidia-offload"; };
    })
  ];
  nixpkgs.config.allowUnfree = true;

  specialisation.safe.configuration = {
    system.nixos.tags = [ "lts" ];
    boot.kernelPackages = lib.mkOverride 98 pkgs.linuxPackages;
    chaotic.mesa-git.enable = lib.mkForce false;
  };

  networking.hostName = "dellvis";
  services.xserver.enable = true;

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users.crookedmirror = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };
  system.stateVersion = "24.11";

  # github:nix-community/* cache
  nix.settings.substituters = [
    "https://nix-community.cachix.org/"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

}
