{ pkgs, ... }: {
  home.packages = with pkgs; [
    btop
    fd
    fastfetch
    ripgrep
    zip
    unzip
    wget
    pciutils
    file
  ];

  programs = {
    bat.enable = true;
    gpg.enable = true;
  };
}
