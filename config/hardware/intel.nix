{
  pkgs,
  config,
  lib,
  ...
}:
{
  # Uncomment line below when installing battery on a laptop
  #powerManagement.cpuFreqGovernor = "powersave";

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.firmware = [ pkgs.linux-firmware ];
}
