{ pkgs, ... }:
{
  home.packages = with pkgs; [
    whois
    dig
    fierce
  ];
}
