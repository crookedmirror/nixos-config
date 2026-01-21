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

  # Scripts for tmux-server service (wochap-style)
  start-tmux-server = pkgs.writeShellScriptBin "start-tmux-server" ''
    # Kill any existing server and start fresh
    ${pkgs.tmux}/bin/tmux kill-server 2>/dev/null || true
    ${pkgs.tmux}/bin/tmux new-session -d -s tmux-server
  '';

  stop-tmux-server = pkgs.writeShellScriptBin "stop-tmux-server" ''
    # Save sessions before stopping (resurrect will handle this via continuum)
    ${pkgs.tmux}/bin/tmux kill-server 2>/dev/null || true
  '';
in
{
  home.packages = [ pkgs.sesh ];

  programs.tmux = {
    enable = true;
  };

  xdg.configFile = {
    "sesh/sesh.toml".source = relativeSymlink configDirectory ./config/sesh.toml;

    "tmux/plugins/resurrect".source = "${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect";
    "tmux/plugins/continuum".source = "${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum";
    "tmux/plugins/yank".source = "${pkgs.tmuxPlugins.yank}/share/tmux-plugins/yank";

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

  # Systemd user service for tmux persistence across reboots (wochap-style)
  # This ensures tmux server starts at login and survives logout
  systemd.user.services.tmux-server = {
    Unit = {
      Description = "tmux server (session persistence)";
      Documentation = "man:tmux(1)";
      After = [ "default.target" ];
    };
    Service = {
      Type = "forking";
      Environment = [
        "TERM=xterm-256color"
        "COLORTERM=truecolor"
      ];
      ExecStart = "${start-tmux-server}/bin/start-tmux-server";
      ExecStop = "${stop-tmux-server}/bin/stop-tmux-server";
      Restart = "on-failure";
      RestartSec = "2";
    };
    Install.WantedBy = [ "default.target" ];
  };

}
