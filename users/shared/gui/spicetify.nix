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
    spicetify.enabledCustomApps = with inputs.spicetify.legacyPackages.${pkgs.system}.apps; [
      marketplace
    ];
    spicetify.enabledExtensions = with inputs.spicetify.legacyPackages.${pkgs.system}.extensions; [
      adblock # hide ads
      hidePodcasts # hide podcasts
      shuffle # agnostic shuffle
      fullScreen # TV Mod
      bookmark # Bookmark any page in spotify
      keyboardShortcut # vim like controls
    ];
    spicetify.theme = inputs.spicetify.legacyPackages.${pkgs.system}.themes.text;
    spicetify.colorScheme = if globals.theme.preferDark then "CatppuccinMocha" else "CatppuccinLatte";
  };
}
