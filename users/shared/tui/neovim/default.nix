# Inspired by https://github.com/ayamir/nvimdots/blob/main/nixos/neovim/default.nix
{
  config,
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
      tree-sitter # nvim-treesitter
      ast-grep # searching
    ];
  };
  xdg.configFile = {
    "nvim".source = lib._custom.relativeSymlink globals.myuser.configDirectory ./config/nvim;
  };
}
