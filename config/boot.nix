{ lib, pkgs, ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "intel_iommu=on"
    "nouveau.config=NvGspRm=1"
    "nouveau.debug=\"GSP=debug\""
  ];
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.initrd.kernelModules = [ 
    "nouveau"
  ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelPackages = lib.mkOverride 99 pkgs.linuxPackages_cachyos;

  specialisation.safe.configuration = {
    system.nixos.tags = [ "lts" ];
    boot.kernelPackages = lib.mkOverride 98 pkgs.linuxPackages;
    chaotic.mesa-git.enable = lib.mkForce false;
  };
}
