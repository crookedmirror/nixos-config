{ pkgs, ... }:
{
  home = {
    username = "crookedmirror";
    homeDirectory = "/home/crookedmirror";
    stateVersion = "24.11";
  };
  nix.package = pkgs.nix;

  imports = [
    ../programs
  ];

}
