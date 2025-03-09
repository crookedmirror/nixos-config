{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs = with lib.mkDefault; {
    spicetify.enable = true;
    spicetify.enabledExtensions = with inputs.spicetify-nix.legacyPackages.${pkgs.system}.extensions; [
      adblock
      hidePodcasts
      shuffle
    ];
    spicetify.theme = lib.mkForce inputs.spicetify-nix.legacyPackages.${pkgs.system}.themes.text;
  };
}
