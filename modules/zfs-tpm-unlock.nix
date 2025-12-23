{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.boot.zfs.tpmUnlock;
in
{
  options.boot.zfs.tpmUnlock = {
    enable = lib.mkEnableOption "ZFS TPM-based key unsealing";

    dataset = lib.mkOption {
      type = lib.types.str;
      description = "The ZFS dataset to encrypt (e.g., zroot/data/encrypted)";
    };

    pcrIndex = lib.mkOption {
      type = lib.types.int;
      default = 15;
      description = "TPM PCR index to seal the key against";
    };

    keyFile = lib.mkOption {
      type = lib.types.path;
      default = "/boot/zfs-key.sealed";
      description = "Location to store the sealed TPM key blob";
    };

    persistentHandle = lib.mkOption {
      type = lib.types.str;
      default = "0x81010001";
      description = "TPM persistent handle for the sealed key";
    };
  };

  config = lib.mkIf cfg.enable {
    # Ensure TPM2 is enabled
    security.tpm2.enable = true;

    # Add tpm2-tools to system packages
    environment.systemPackages = with pkgs; [
      tpm2-tools
      tpm2-tss
    ];

    # Activation script to set up TPM sealing on first boot
    system.activationScripts.zfsTPMSetup = lib.stringAfter [ "var" ] ''
      # Only run if the key doesn't already exist
      if [ ! -f "${cfg.keyFile}" ]; then
        echo "Setting up ZFS TPM encryption key..."

        # Create temporary directory for TPM operations
        TMPDIR=$(${pkgs.coreutils}/bin/mktemp -d)
        trap "${pkgs.coreutils}/bin/rm -rf $TMPDIR" EXIT

        cd $TMPDIR

        # Generate 32-byte random key for ZFS
        ${pkgs.coreutils}/bin/dd if=/dev/urandom of=zfs.key bs=32 count=1 2>/dev/null

        # Create primary key in owner hierarchy
        ${pkgs.tpm2-tools}/bin/tpm2_createprimary -C o -g sha256 -G rsa -c primary.ctx 2>/dev/null || {
          echo "Warning: Failed to create TPM primary key. TPM may not be available yet."
          echo "You'll need to seal the key manually after first boot."
          exit 0
        }

        # Create sealed key object with PCR policy
        ${pkgs.tpm2-tools}/bin/tpm2_create \
          -C primary.ctx \
          -g sha256 \
          -G keyedhash \
          -r key.priv \
          -u key.pub \
          -i zfs.key \
          -L "pcr:sha256:${toString cfg.pcrIndex}" 2>/dev/null || {
          echo "Warning: Failed to seal key to TPM"
          exit 0
        }

        # Load key into TPM
        ${pkgs.tpm2-tools}/bin/tpm2_load \
          -C primary.ctx \
          -r key.priv \
          -u key.pub \
          -c key.ctx 2>/dev/null || {
          echo "Warning: Failed to load key into TPM"
          exit 0
        }

        # Persist the key to a persistent handle
        ${pkgs.tpm2-tools}/bin/tpm2_evictcontrol \
          -C o \
          -c key.ctx \
          ${cfg.persistentHandle} 2>/dev/null || {
          echo "Warning: Failed to persist key handle"
        }

        # Also store the raw key for initial dataset creation
        ${pkgs.coreutils}/bin/mkdir -p /run/keys
        ${pkgs.coreutils}/bin/cp zfs.key /run/keys/zfs-encryption-key
        ${pkgs.coreutils}/bin/chmod 600 /run/keys/zfs-encryption-key

        # Create marker file to indicate setup is complete
        ${pkgs.coreutils}/bin/touch "${cfg.keyFile}"
        ${pkgs.coreutils}/bin/chmod 644 "${cfg.keyFile}"

        echo "TPM key sealing complete. Initial key available at /run/keys/zfs-encryption-key"
        echo "Use this to manually create the encrypted dataset, then reboot."
      fi
    '';
  };
}
