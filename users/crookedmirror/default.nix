{ pkgs, ... }:

let
  username = "crookedmirror";
in
{
  users.users.crookedmirror = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "dialout"
      "networkmanager"
      "tss"
    ];
    shell = pkgs.zsh;
  };

  home-manager.users.${username} = {
    imports = [
      ../shared
      ../../home/users/crookedmirror_dellvis.nix
    ];
    home = {
      username = "crookedmirror";
      homeDirectory = "/home/crookedmirror";
      stateVersion = "24.11";
    };
  };
}
