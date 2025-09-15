{
  pkgs,
  inputs,
  globals,
  ...
}:
let
  theme = {
    src = "${inputs.catppuccin-eza}/themes/${globals.theme.colors.flavour}";
    file = "catppuccin-${globals.theme.colors.flavour}-mauve.yml";
  };
in
{
  home.packages = [ pkgs.eza ];

  home.shellAliases = {
    "ll" = "eza -lhF --group-directories-first";
    "lla" = "eza -lahF --group-directories-first";
  };

  xdg.configFile = {
    "eza/theme.yml".source = "${theme.src}/${theme.file}";
  };
}
