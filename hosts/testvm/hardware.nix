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
  boot.supportedFilesystems = [ "zfs" ];

  networking.useDHCP = lib.mkDefault true;
}
