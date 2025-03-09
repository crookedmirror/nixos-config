{ lib, pkgs, ... }:
{

  environment = {
    systemPackages = with pkgs; [
      vulkan-caps-viewer
      vulkanPackages_latest.vulkan-tools
      nvidia-offload
    ];

    variables = {
      "VK_DRIVER_FILES" =
        "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/intel_icd.i686.json";
      "LIBVA_DRIVER_NAME" = "iHD";
    };
  };

  boot.kernelParams = [
    "intel_iommu=on"
    "nouveau.config=NvGspRm=1"
    "nouveau.debug=\"GSP=debug\""
  ];
  boot.initrd.kernelModules = [ "nouveau" ];

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
      nvidia-offload = final.callPackage ./scripts { scriptName = "nvidia-offload"; };
    })
  ];
  boot.kernelPackages = lib.mkOverride 99 pkgs.linuxPackages_cachyos;
  chaotic.hdr.enable = lib.mkForce false;

  specialisation.safe.configuration = {
    system.nixos.tags = [ "lts" ];
    boot.kernelPackages = lib.mkOverride 98 pkgs.linuxPackages;
    chaotic.mesa-git.enable = lib.mkForce false;
  };
}
