{
  config,
  lib,
  inputs,
  pkgs,
  globals,
  ...
}:
{
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty_git; # chaotic
    settings = {
      general.import = [ "${config.xdg.configHome}/alacritty/theme.toml" ];
      window.opacity = lib.mkForce 0.95;
      font.normal.family = "Hack Nerd Font";
      font.size = 13.0;
      #keyboard.bindings = lib.trivial.importJSON "${./..}/alacritty/key-bindings.json";
      terminal.shell = {
        program = "${pkgs.tmux}/bin/tmux";
        args = [
          "new-session"
          "-A"
          "-s"
          "regular"
        ];
      };
    };
  };
  xdg.configFile = {
    "alacritty/theme.toml".source =
      "${inputs.catppuccin-alacritty}/catppuccin-${globals.theme.colors.flavour}.toml";
  };

}
