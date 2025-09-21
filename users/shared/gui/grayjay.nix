{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    (if config.nonNixos.enable then (config.lib.nixGL.wrap grayjay) else grayjay)
  ];
}
