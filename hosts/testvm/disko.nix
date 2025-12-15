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
              size = "1G";
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
          # Root (ephemeral - wipes on reboot)
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

          # Nix store (persistent)
          "ROOT/nix" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/nix";
          };

          # Persistent data
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
