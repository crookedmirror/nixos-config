# chaotic.zfs-impermanence-on-shutdown (EOL)
# https://github.com/chaotic-cx/nyx/blob/aacb796ccd42be1555196c20013b9b674b71df75/modules/nixos/zfs-impermanence-on-shutdown.nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.zfs-impermanence;
  cfgZfs = config.boot.zfs;
in
{
  options = with lib; {
    services.zfs-impermanence = {
      enable = mkEnableOption "Impermanence on safe-shutdown through ZFS snapshots";

      volume = mkOption {
        type = types.str;
        default = null;
        example = "zroot/ROOT/empty";
        description = ''
          Full description to the volume including pool.
          This volume must have a snapshot to an "empty" state.

          WARNING: The volume will be rolled back to the snapshot on every safe-shutdown.
        '';
      };

      snapshot = mkOption {
        type = types.str;
        default = null;
        example = "start";
        description = ''
          Snapshot of the volume in an "empty" state to roll back to.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Run in shutdown ramfs for maximum reliability
    systemd.shutdownRamfs.contents."/etc/systemd/system-shutdown/zpool".source = lib.mkForce (
      pkgs.writeShellScript "zfs-impermanence-rollback" ''
        ${cfgZfs.package}/bin/zfs rollback -r "${cfg.volume}@${cfg.snapshot}"
        exec ${cfgZfs.package}/bin/zpool sync
      ''
    );

    # Ensure ZFS tools are available in shutdown ramfs
    systemd.shutdownRamfs.storePaths = [ "${cfgZfs.package}/bin/zfs" ];

    # Declare root filesystem
    fileSystems."/" = {
      device = cfg.volume;
      fsType = "zfs";
      neededForBoot = true;
    };
  };
}
