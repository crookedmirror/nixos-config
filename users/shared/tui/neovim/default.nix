{ globals, lib, ... }:
{
  programs.neovim.enable = true;

  xdg.configFile = {
    "nvim".source = lib._custom.relativeSymlink globals.myuser.configDirectory ./config/nvim;
  };
}
