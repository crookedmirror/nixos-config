{ modulesPath, lib, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = [
    "virtio_scsi"
  ];
  boot.kernelModules = [ "kvm-intel" ];

  # ZFS support
  boot.supportedFilesystems = [
    "zfs"
    "vfat"
  ];

  networking.useDHCP = lib.mkDefault true;
}
