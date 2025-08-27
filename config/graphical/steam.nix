{ config, pkgs, lib, ... }:
{
  programs.steam = {
    enable = true;
    gamescopeSession = {
      enable = true; # Gamescope session is better for AAA gaming.
      args = [ "--immediate-flips" "-w" "1920" "-h" "1080" "--" "bigsteam"];
    };
    extraCompatPackages = with pkgs; [
      #proton-ge-custom #currently broken in chaotic
    ];

  };
  
  # The default's CLI gamescope.
  programs.gamescope = {
    enable = true;
    capSysNice = true;
    package = pkgs.gamescope_git;
  };
  
  # Gamescope without wrapper, but with right capabilities
  security.wrappers.valve-gamescope = {
    owner = "root";
    group = "root";
    source = "${pkgs.gamescope_git}/bin/gamescope";
    capabilities = "cap_sys_nice+pie";
  };
  environment.variables.GAMESCOPE_NOWRAP = "${config.security.wrapperDir}/valve-gamescope";

  # Gamescope untouched (no wrapper, no capabilities) in a fixed-path place
  fileSystems."/opt/gamescope" = {
    device = pkgs.gamescope_git.outPath;
    fsType = "none";
    options = [ "bind" "ro" "x-gvfs-hide" ];
  };
  
  # Smooth-criminal bleeding-edge Mesa3D
  chaotic.mesa-git = {
    enable = true;
    fallbackSpecialisation = false;
  };
}
