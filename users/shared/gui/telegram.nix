{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    (if config.nonNixos.enable then (config.lib.nixGL.wrap ayugram-desktop) else ayugram-desktop)
  ];
}
