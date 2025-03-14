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

  services.udev = {
    extraRules = ''
      			KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
      		'';
  };

  environment = {
    systemPackages = with pkgs; [
      vulkan-caps-viewer
      vulkanPackages_latest.vulkan-tools
      vim
      git
      home-manager
      nvidia-offload
      lutris
    ];

    variables = {
      "VK_DRIVER_FILES" =
        "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/intel_icd.i686.json";
      "LIBVA_DRIVER_NAME" = "iHD";
    };
  };
  programs.corectrl.enable = true;

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

  hardware.opengl = {
    enable = true;
  };

  nixpkgs.overlays = [
    (final: prev: {
      nvidia-offload = final.callPackage ./../modules/scripts { scriptName = "nvidia-offload"; };
      anime4k = final.callPackage ./../modules/anime4k.nix { };
    })
  ];
  nixpkgs.config.allowUnfree = true;

  specialisation.safe.configuration = {
    system.nixos.tags = [ "lts" ];
    boot.kernelPackages = lib.mkOverride 98 pkgs.linuxPackages;
    chaotic.mesa-git.enable = lib.mkForce false;
  };

  networking.hostName = "dellvis";

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  time.timeZone = "Europe/Zurich";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
  ];

   services.xserver = {
    enable = true;
   xkb = {
    layout = "us, ru";
   variant = "qwerty";
  options = "grp:alt_shift_toggle";
  };
  };

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
    "https://chaotic-nyx.cachix.org/"
    "https://nix-community.cachix.org/"
    "https://hyprland.cachix.org"
    "https://cache.garnix.io"
  ];
  nix.settings.trusted-public-keys = [
    "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
  ];

  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/porsche" = {
    device = "/dev/disk/by-uuid/C88E64058E63EB00";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
    ];
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    systemWide = false;

    wireplumber.enable = true;
  };
  services.pulseaudio.enable = false;
  security.rtkit.enable = true; # OpenAL likes it, but my pipewire is not configure to rt.
  environment.variables.AE_SINK = "ALSA"; # For Kodi, better latency/volume under pw.
  environment.variables.SDL_AUDIODRIVER = "pipewire";
  environment.variables.ALSOFT_DRIVERS = "pipewire";

  security.polkit.enable = true;

  # Up-to 192kHz in the NI Audio 6
  services.pipewire.extraConfig.pipewire."99-playback-96khz" = {
    "context.properties" = {
      "default.clock.rate" = 96000;
      "default.clock.allowed-rates" = [
        44100
        48000
        88200
        96000
        176400
        192000
      ];
    };
  };

}
