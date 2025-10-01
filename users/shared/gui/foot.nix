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

    [key-bindings]
    #scrolling is handled by tmux
    scrollback-up-page=none 
    scrollback-down-page=none

    spawn-terminal=none #unblock ctrl-shift-n
    unicode-input=none #unblock ctrl-shift-u

    #history search is handled by zsh
    prompt-prev=none
    prompt-next=none

    [text-bindings]
    \x1b[98;6u=Control+Shift+b
    \x1b[100;6u=Control+Shift+d
    \x1b[102;6u=Control+Shift+f
    \x1b[108;6u=Control+Shift+l
    \x1b[110;6u=Control+Shift+n
    \x1b[112;6u=Control+Shift+p
    \x1b[113;6u=Control+Shift+q
    \x1b[116;6u=Control+Shift+t
    \x1b[117;6u=Control+Shift+u
    \x1b[119;6u=Control+Shift+w

    ${builtins.readFile "${inputs.catppuccin-foot}/themes/catppuccin-${colors.flavour}.ini"}
    cursor=${unwrapHex colors.base} ${unwrapHex colors.green}
  '';
}
