{ pkgs, lib, ... }:
{

  programs.mangohud = {
    enable = true;
    package = pkgs.mangohud_git;

    settings = {
      # functionality
      gl_vsync = 0;
      vsync = 1;

      # appearance
      horizontal = true;
      hud_compact = true;
      hud_no_margin = true;
      table_columns = 19;
      font_size = lib.mkForce 16;
      background_alpha = lib.mkForce "0.05";

      # additional features
      # battery = hasBattery;
      cpu_temp = true;
      gpu_junction_temp = true;
      io_read = true;
      io_write = true;
      vram = true;
      wine = true;

      # cool, but not always necessary
      # keeping here for remembering
      # arch = true;
      # vulkan_driver = true;
      # gpu_name = true;
      # engine_version = true;
    };
  };
}
