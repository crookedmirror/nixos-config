{ config, lib, pkgs, ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "intel_iommu=on"
    "nouveau.config=NvGspRm=1"
    "nouveau.debug=\"GSP=debug\""
  ];
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
    "i915"
  ];
  boot.initrd.kernelModules = [ 
    "nouveau"
  ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelPackages = lib.mkOverride 99 pkgs.linuxPackages_cachyos;

  specialisation.safe.configuration = {
    system.nixos.tags = [ "lts" ];
    boot.kernelPackages = lib.mkOverride 98 pkgs.linuxPackages;
    chaotic.mesa-git.enable = lib.mkForce false;
  };
  
  # Video Acceleration
  chaotic.mesa-git.extraPackages = with pkgs; [ intel-media-driver ];

    # System-wide changes
  environment = {
    # Prefer intel unless told so
    variables = {
      "WLR_DRM_DEVICES" = "/dev/dri/card1";
      "VK_DRIVER_FILES" = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/intel_icd.i686.json";
      "LIBVA_DRIVER_NAME" = "iHD";
    };
  };
  # Intel VAAPI (NVIDIA enable its own)
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
  ];
}
