{ lib, ... }: { 
  networking.useDHCP = lib.mkDefault true;
  networking.hostId = "adbd9e24";
}
