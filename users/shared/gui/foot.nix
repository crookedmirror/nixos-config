{
  lib,
  globals,
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (globals.theme) colors;
  unwrapHex = str: builtins.substring 1 (builtins.stringLength str) str;
in
{
  home.packages = with pkgs; [ foot ];

  xdg.configFile."foot/foot.ini".text = ''
    [main]
    shell=${pkgs.tmux}/bin/tmux new-session -A -s regular

    font=IosevkaTerm NF:size=13:weight=medium
    font-bold=IosevkaTerm NF Heavy:size=13:weight=heavy
    font-italic=IosevkaTerm NF:size=13:weight=medium:slant=italic
    font-bold-italic=IosevkaTerm NF Heavy:size=13:weight=heavy:slant=italic

    [text-bindings]
    \x1b[98;6u=Control+Shift+b
    \x1b[116;6u=Control+Shift+t
    \x1b[113;6u=Control+Shift+q

    ${builtins.readFile "${inputs.catppuccin-foot}/themes/catppuccin-${colors.flavour}.ini"}
    cursor=${unwrapHex colors.base} ${unwrapHex colors.green}
  '';
}
