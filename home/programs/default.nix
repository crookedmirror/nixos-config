{ pkgs, inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    qbittorrent
    inputs.grayjay.packages.${pkgs.system}.grayjay
    inputs.ayugram-desktop.packages.${pkgs.system}.ayugram-desktop

    # Privacy
    keepassxc
    feather
    tor-browser
  ];

  imports = [
    ./git.nix
    ./bash.nix
    ./librewolf.nix
    ./gaming.nix
    ./spicetify.nix
  ];
}
