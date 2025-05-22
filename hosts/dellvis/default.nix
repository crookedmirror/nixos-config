{ inputs, pkgs, ... }:
{
  imports = [

    ../../config

    ../../config/hardware/mesa.nix
    ../../config/hardware/intel.nix
    ../../config/hardware/ergohaven.nix
    ../../config/hardware/ni-audio-6.nix
    ../../config/graphical  

    ../../users/crookedmirror
  
    ./fs.nix
    ./net.nix
  ];
  nixpkgs.hostPlatform = "x86_64-linux";

  #boot.supportedFilesystems = [ "ntfs" ];
  #fileSystems."/porsche" = {
  #  device = "/dev/disk/by-uuid/C88E64058E63EB00";
  #  fsType = "ntfs-3g";
  #  options = [
  #    "rw"
  #    "uid=1000"
  #  ];
  #};  

  environment = {
    systemPackages = with pkgs; [
      vim
      git
      scripts.nvidia-offload
      corectrl
    ];
};
  
}
