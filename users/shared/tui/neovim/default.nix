{
  globals,
  lib,
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      ripgrep
    ];
  };

  programs.neovim = {
    enable = true;

    withNodeJs = false;
    withPython3 = false;
    withRuby = false;

    extraPackages = with pkgs; [
      tree-sitter
      ast-grep
    ];
  };
  xdg.configFile = {
    "nvim".source = lib._custom.relativeSymlink globals.myuser.configDirectory ./config/nvim;
  };
}
