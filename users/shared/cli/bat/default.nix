{
  lib,
  pkgs,
  inputs,
  globals,
  ...
}:
let
  inherit (globals.theme) colors;
in
{
  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin ${colors.flavourCap}";
    };
    themes = {
      "Catppuccin ${colors.flavourCap}" = {
        src = "${inputs.catppuccin-bat}/themes";
        file = "Catppuccin ${colors.flavourCap}.tmTheme";
      };
    };
  };

  programs.zsh.initContent = lib.mkOrder 1000 (builtins.readFile ./functions.zsh);

  home.shellAliases = {
    cat = "bat --plain";
  };
}
