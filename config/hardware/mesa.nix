{ pkgs, ... }:
{  
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

  #environment = {
  #  variables = {
  #    "vk_driver_files" =
  #      "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/intel_icd.i686.json";
  #    "libva_driver_name" = "ihd";
  #  };
  #};
}
