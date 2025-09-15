{
  config,
  pkgs,
  inputs,
  globals,
  ...
}:
let
  inherit (globals.theme) colors;
in
{
  programs.tmux = {
    enable = true;
  };

  xdg.configFile = {
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

      run-shell ~/.config/tmux/plugins/catppuccin/catppuccin.tmux
      run-shell ${config.xdg.configHome}/tmux/plugins/status-bar/status-bar.tmux

      set -g mouse off
      source-file ${config.xdg.configHome}/tmux/config.conf
    '';
    "tmux/config.conf".source = ./config.conf;
    "tmux/plugins/status-bar/status-bar.tmux" = {
      source = ./status-bar.tmux;
      executable = true;
    };
  };

}
