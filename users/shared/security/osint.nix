{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jwhois
  ];
}
