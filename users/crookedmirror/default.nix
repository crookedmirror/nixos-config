{ pkgs, ... }:

  let
    username = "crookedmirror";
  in
  {
  users.users.crookedmirror = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };


    home-manager.users.${username} = {
      imports = [
        ../config
        ../../home/users/crookedmirror_dellvis.nix
      ];
      home = {
        username = "crookedmirror";
        homeDirectory = "/home/crookedmirror";
        stateVersion = "24.11";
      };
    };
  } 
