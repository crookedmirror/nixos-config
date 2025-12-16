{ modulesPath, lib, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_blk"
    "ahci"
  ];
  boot.kernelModules = [ "kvm-intel" ];

  # ZFS support
  boot.supportedFilesystems = [
    "zfs"
    "vfat"
  ];
  boot.initrd.supportedFilesystems = [ "zfs" ]; # Critical for root on ZFS

  networking.useDHCP = lib.mkDefault true;
}
