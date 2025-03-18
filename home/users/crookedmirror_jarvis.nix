{ pkgs, ... }:
{
  home = {
    username = "crookedmirror";
    homeDirectory = "/home/crookedmirror";
    stateVersion = "24.11";

    packages = with pkgs; [
      bat
    ];
  };
  nix.package = pkgs.nix;
  nixpkgs.config.allowUnfree = true;

  imports = [
    ../programs/bash.nix
    ../programs/git.nix
    ../programs/librewolf.nix
  ];

}
