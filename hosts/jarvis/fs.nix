{
  fileSystems."/nix" =
    {
      device = "zroot/ROOT/nix";
      fsType = "zfs";
      neededForBoot = true;
    };

  fileSystems."/var/persistent" =
    {
      device = "zroot/data/persistent";
      fsType = "zfs";
      neededForBoot = true;
    };

  fileSystems."/var/residues" =
    # Like "persistent", but for cache and stuff I'll never need to backup.
    {
      device = "zroot/ROOT/residues";
      fsType = "zfs";
      neededForBoot = true;
    };

  fileSystems."/home/vkokurin/Downloads" =
    {
      device = "zroot/data/downloads";
      fsType = "zfs";
    };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/172A-13EA";
    fsType = "vfat";
  };
}
