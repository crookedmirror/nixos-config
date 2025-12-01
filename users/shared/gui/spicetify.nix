{
  pkgs,
  inputs,
  globals,
  ...
}:
{
  programs.spicetify = {
    enable = true;
    enabledCustomApps = with inputs.spicetify.legacyPackages.${pkgs.system}.apps; [
      marketplace
    ];
    enabledExtensions = with inputs.spicetify.legacyPackages.${pkgs.system}.extensions; [
      adblock # hide ads
      hidePodcasts # hide podcasts
      shuffle # agnostic shuffle
      #fullScreen # TV Mod - Conflicts with keyboardShortcuts
      bookmark # Bookmark any page in spotify
      keyboardShortcut # vim like controls
    ];
    theme = inputs.spicetify.legacyPackages.${pkgs.system}.themes.text;
    colorScheme = if globals.theme.preferDark then "CatppuccinMocha" else "CatppuccinLatte";
  };
}
