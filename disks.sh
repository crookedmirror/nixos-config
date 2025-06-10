mkfs.vfat -F32 /dev/sda1

zpool create -f zroot /dev/sda2
zpool set autotrim=on zroot
zfs set compression=lz4 zroot
zfs set mountpoint=none zroot
zfs create -o refreservation=4G -o mountpoint=none zroot/reserved

# System volumes.
zfs create -o mountpoint=none zroot/data
zfs create -o mountpoint=none zroot/ROOT
zfs create -o mountpoint=legacy zroot/ROOT/empty
zfs create -o mountpoint=legacy zroot/ROOT/nix
zfs create -o mountpoint=legacy zroot/data/persistent

# Different recordsize
zfs create -o mountpoint=legacy -o recordsize=16K -o compression=off zroot/data/downloads


# Encrypted volumes.
zfs create -o encryption=on -o keyformat=passphrase -o mountpoint=/home/vkokurin/.encrypted zroot/data/encrypted
zfs create -o encryption=on -o keyformat=passphrase -o mountpoint=/home/vkokurin/.mozilla zroot/data/mozilla

# Init structure
mount -t zfs zroot/ROOT/empty /mnt
mkdir -p /mnt/nix /mnt/var/persistent /mnt/boot /mnt/home/pedrohlc/Downloads
zfs snapshot zroot/ROOT/empty@start

# Mount & Permissions
mount /dev/sda1 /mnt/boot
chmod 700 /mnt/boot
mount -t zfs zroot/ROOT/nix /mnt/nix
mount -t zfs zroot/data/downloads /mnt/home/vkokurin/Downloads
chown -R 1001:100 /mnt/home/vkokurin
mount -t zfs zroot/data/persistent /mnt/var/persistent
