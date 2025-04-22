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

  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/porsche" = {
    device = "/dev/disk/by-uuid/C88E64058E63EB00";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
    ];
  };  

  users.users.crookedmirror = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };


  environment = {
    systemPackages = with pkgs; [
      vulkan-caps-viewer
      vulkanPackages_latest.vulkan-tools
      vim
      git
      home-manager
      scripts.nvidia-offload
      lutris
    ];
};
}
