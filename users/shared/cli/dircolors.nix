{
  lib,
  inputs,
  globals,
  pkgs,
  ...
}:
{
  home.file = {
    ".dir_colors".source =
      "${inputs.catppuccin-dircolors}/themes/catppuccin-${globals.theme.colors.flavour}/.dircolors";
  };

  programs.zsh.initContent = lib.mkOrder 550 ''
    eval $(${lib.getExe' pkgs.coreutils "dircolors"} -b ~/.dir_colors)
  '';

  programs.dircolors.enable = false;
}
