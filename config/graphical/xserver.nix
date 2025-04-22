{
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us,ru";
      options = "grp:alt_shift_toggle";
    };
  };
}
