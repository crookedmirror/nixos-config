{ modulesPath, lib, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = [
    "virtio_scsi"
    "tpm_tis"
    "tpm_crb"
  ];
  boot.kernelModules = [ "kvm-intel" ];

  networking.useDHCP = lib.mkDefault true;
}
