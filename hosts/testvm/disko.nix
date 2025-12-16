{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "5G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };

    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          compression = "lz4";
          mountpoint = "none";
        };

        datasets = {
          "ROOT" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };

          "ROOT/empty" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/";
            postCreateHook = "zfs snapshot zroot/ROOT/empty@start";
          };

          "ROOT/nix" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/nix";
          };

          "data" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };

          "data/persistent" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/var/persistent";
          };
        };
      };
    };
  };
}
