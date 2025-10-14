{
  lib,
  config,
  pkgs,
  inputs,
  globals,
  ...
}:
let
  inherit (globals.theme) colors;
  inherit (globals.myuser) configDirectory;
  inherit (lib._custom) relativeSymlink;
in
{
  programs.tmux = {
    enable = true;
  };

  xdg.configFile = {
    "tmux/plugins/tmux-sessionx".source =
      "${pkgs.tmuxPlugins.tmux-sessionx}/share/tmux-plugins/sessionx";
    "tmux/plugins/catppuccin".source = inputs.catppuccin-tmux;
    "tmux/plugins/sensible".source = "${pkgs.tmuxPlugins.sensible}/share/tmux-plugins/sensible";
    "tmux/tmux.conf".text = ''
      set -gu default-command
      set -g default-shell ${pkgs.zsh}/bin/zsh

      # catppuccin theme
      set -g popup-border-style "bg=default,fg=${colors.primary}"
      set -g @catppuccin_flavour "${colors.flavour}"
      set -g @catppuccin_pane_active_border_style "fg=${colors.primary}"
      set -g @catppuccin_pane_border_style "fg=${colors.border}"

      #FIXME: the status bar theme is not chaning for Latte
      set -g @catppuccin_status_default "off"
      set -g @catppuccin_status_background 'default'

      set -g pane-border-lines single
      set -g popup-border-lines rounded
      set -g status off

      run-shell ${config.xdg.configHome}/tmux/plugins/catppuccin/catppuccin.tmux
      run-shell ${config.xdg.configHome}/tmux/plugins/status-bar/status-bar.tmux

      source-file ${config.xdg.configHome}/tmux/config.conf
    '';
    "tmux/config.conf".source = relativeSymlink configDirectory ./config/config.conf;
    "tmux/plugins/status-bar/status-bar.tmux".source =
      relativeSymlink configDirectory ./config/status-bar.tmux;
  };

}
