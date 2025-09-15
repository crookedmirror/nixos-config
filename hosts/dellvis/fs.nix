{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/88136b8e-d669-4712-865a-e5fde573f7ef";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A936-4157";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/porsche" = {
    device = "/dev/disk/by-uuid/C88E64058E63EB00";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
    ];
  };
}
