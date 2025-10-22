{
  lib,
  globals,
  inputs,
  pkgs,
  ...
}:
let
  inherit (globals.theme) colors;
in
{
  home.packages = with pkgs; [
    foot
    libsixel
  ];

  xdg.configFile."foot/foot.ini".text = ''
    ${builtins.readFile "${inputs.catppuccin-foot}/themes/catppuccin-${colors.flavour}.ini"}
    cursor=${lib._custom.unwrapHex colors.base} ${lib._custom.unwrapHex colors.green}

    [main]
    shell=${pkgs.tmux}/bin/tmux new-session -A -s regular
    include=${lib._custom.relativeSymlink globals.myuser.configDirectory ./config/foot.ini}
  '';
}
