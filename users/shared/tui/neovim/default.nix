{
  config,
  globals,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    tree-sitter
    ripgrep
  ];

  programs.neovim = {
    enable = true;
  };

  xdg.configFile = {
    "nvim".source = lib._custom.relativeSymlink globals.myuser.configDirectory ./config/nvim;
  };
}
