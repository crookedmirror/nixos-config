{
  config,
  pkgs,
  inputs,
  ...
}:
let
  mpv-hq-entry = pkgs.runCommand "mpv-hq.desktop" { } ''
    mkdir -p $out/share/applications
    cp ${config.programs.mpv.package}/share/applications/mpv.desktop $out/share/applications/mpv-hq.desktop
    substituteInPlace $out/share/applications/mpv-hq.desktop \
      --replace "Exec=mpv --" "Exec=mpv --profile=hq --" \
      --replace "Name=mpv" "Name=mpv-hq"
  '';
in
{
  nixpkgs.config.allowUnfree = true;

  programs.dwl.enable = true;

  home.packages = with pkgs; [
    vial
    thunderbird-latest-unwrapped

    sakura

    qbittorrent
    inputs.grayjay.packages.${pkgs.system}.grayjay
    inputs.ayugram-desktop.packages.${pkgs.system}.ayugram-desktop

    # Privacy
    keepassxc
    feather
    tor-browser

    # Custom desktop applications
    mpv-hq-entry
  ];

  imports = [
    ./git.nix
    ./bash.nix
    ./librewolf.nix
    ./gaming.nix
    ./spicetify.nix
    ./mpv.nix
    ./dwl.nix
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "video/x-matroska" = "mpv-hq.desktop";
      "video/x-msvideo" = "mpv-hq.desktop";
    };
  };
}
