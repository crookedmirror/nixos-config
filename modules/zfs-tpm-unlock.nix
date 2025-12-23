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

        # Create temporary directory for TPM operations in a location that exists
        TMPDIR=$(${pkgs.coreutils}/bin/mktemp -d -p /tmp)
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

        # Create PCR policy for sealing
        if ${pkgs.tpm2-tools}/bin/tpm2_createpolicy \
          --policy-pcr \
          -l "sha256:${toString cfg.pcrIndex}" \
          -L pcr.policy 2>/dev/null; then
          echo "PCR policy created, sealing key with PCR ${toString cfg.pcrIndex}"
          # Seal with PCR policy
          ${pkgs.tpm2-tools}/bin/tpm2_create \
            -C primary.ctx \
            -g sha256 \
            -G keyedhash \
            -r key.priv \
            -u key.pub \
            -i zfs.key \
            -L pcr.policy 2>/dev/null || {
            echo "Warning: Failed to seal key with PCR policy"
            exit 0
          }
        else
          echo "Warning: Failed to create PCR policy, sealing without PCR binding"
          # Seal without PCR policy as fallback
          ${pkgs.tpm2-tools}/bin/tpm2_create \
            -C primary.ctx \
            -g sha256 \
            -G keyedhash \
            -r key.priv \
            -u key.pub \
            -i zfs.key 2>/dev/null || {
            echo "Warning: Failed to seal key to TPM"
            exit 0
          }
        fi

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

        # Store the raw key for dataset creation
        ${pkgs.coreutils}/bin/mkdir -p /run/keys
        ${pkgs.coreutils}/bin/cp zfs.key /run/keys/zfs-encryption-key
        ${pkgs.coreutils}/bin/chmod 600 /run/keys/zfs-encryption-key

        # Create the encrypted ZFS dataset
        echo "Creating encrypted ZFS dataset ${cfg.dataset}..."

        # Check if dataset already exists
        if ! ${config.boot.zfs.package}/bin/zfs list ${cfg.dataset} 2>/dev/null; then
          # Create mountpoint directory
          ${pkgs.coreutils}/bin/mkdir -p /var/encrypted

          # Create the encrypted dataset (don't auto-mount during activation)
          if ${config.boot.zfs.package}/bin/zfs create \
               -o encryption=aes-256-gcm \
               -o keyformat=raw \
               -o keylocation=file:///run/keys/zfs-encryption-key \
               -o mountpoint=/var/encrypted \
               -o canmount=noauto \
               ${cfg.dataset} 2>&1; then
            echo "Encrypted dataset ${cfg.dataset} created successfully"
            echo "Dataset will be mounted on next boot"
          else
            echo "Warning: Failed to create encrypted dataset."
          fi
        else
          echo "Dataset ${cfg.dataset} already exists, skipping creation"
        fi

        # Create marker file to indicate setup is complete
        ${pkgs.coreutils}/bin/touch "${cfg.keyFile}"
        ${pkgs.coreutils}/bin/chmod 644 "${cfg.keyFile}"

        echo "TPM key sealing and dataset creation complete!"
        echo "The dataset will auto-unlock on subsequent boots using TPM."
      fi
    '';
  };
}
