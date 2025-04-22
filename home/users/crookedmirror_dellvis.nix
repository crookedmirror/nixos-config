{ pkgs, ... }:
{
  home = {
    username = "crookedmirror";
    homeDirectory = "/home/crookedmirror";
    stateVersion = "24.11";
  };

  imports = [
    ../programs
  ];

}
