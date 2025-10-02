{
  pkgs,
  lib,
  globals,
  config,
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
  mkThemeScript =
    colors:
    lib.concatStringsSep "\n" (
      lib.attrsets.mapAttrsToList (key: value: ''${key}="${value}"'') (
        builtins.removeAttrs colors [ "flavour" ]
      )
    );
in
{
  imports = [
    ../modules
    ./dev
    ./gui
    ./cli
    ./tui
    ./security
  ];

  home.shellAliases = {
    ls = "ls --color=auto";
    l = "ls -lahF --group-directories-first --show-control-chars --quoting-style=escape --color=auto";
    md = "mkdir";
    rmd = "rm --one-file-system -d";
    cp = "cp -vi";
    cpr = "rsync -axHAWXS --numeric-ids --info=progress2";
    mv = "mv -vi";
  };

  home.packages = with pkgs; [
    btop
    fd
    ripgrep
    zip
    p7zip
    unzip
    wget
    pciutils
    file
    nerd-fonts.hack
    fzf
    traceroute
    bluetui

    thunderbird

    arduino-ide
    tree

    qbittorrent
    #grayjay

    nix-tree
    nix-top_abandoned # chaotic

    ungoogled-chromium

    # Privacy
    keepassxc
    feather
    tor-browser

    # Custom desktop applications
    mpv-hq-entry
  ];

  home.file = {
    ".bashrc".text = ''
      unset HISTFILE
    '';
    ".bash_profile".text = ''
      [[ -f ~/.bashrc ]] && . ~/.bashrc
    '';
  };

  xdg.configFile = {
    "scripts/theme-colors.sh" = {
      text = "${mkThemeScript globals.theme.colors}";
      executable = true;
    };
  };

  programs = {
    gpg.enable = true;
    neovim.enable = true;
  };
}
