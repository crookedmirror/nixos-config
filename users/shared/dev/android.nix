{ pkgs, ... }:
{
  home.packages = with pkgs; [
    android-tools # adb, fastboot, etc.
  ];
}
