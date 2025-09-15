{
  lib,
  pkgs,
  inputs,
  globals,
  ...
}:
{
  programs = with lib.mkDefault; {
    spicetify.enable = true;
    spicetify.enabledExtensions = with inputs.spicetify.legacyPackages.${pkgs.system}.extensions; [
      adblock
      hidePodcasts
      shuffle
      bookmark
      keyboardShortcut
    ];
    spicetify.theme = inputs.spicetify.legacyPackages.${pkgs.system}.themes.text;
    spicetify.colorScheme = if globals.theme.preferDark then "CatppuccinMocha" else "CatppuccinLatte";
  };
}
