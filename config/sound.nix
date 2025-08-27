{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    systemWide = false;

    wireplumber.enable = true;
  };
  services.pulseaudio.enable = false;
  security.rtkit.enable = true; # OpenAL likes it, but my pipewire is not configure to rt.
  environment.variables.AE_SINK = "ALSA"; # For Kodi, better latency/volume under pw.
  environment.variables.SDL_AUDIODRIVER = "pipewire";
  environment.variables.ALSOFT_DRIVERS = "pipewire";
}
