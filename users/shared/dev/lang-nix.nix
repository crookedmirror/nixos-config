{ pkgs, ... }:
{
  home.packages = with pkgs; [
    statix
    nixfmt
    nixd
    deadnix
  ];
}
