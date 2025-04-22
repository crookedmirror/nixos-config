{ pkgs, ... }:

  let
    myuser = "crookedmirror";
  in
  {
    home-manager.users.${myuser} = {
      imports = [
        ../../home/users/crookedmirror_dellvis.nix
      ];
    };
  } 

