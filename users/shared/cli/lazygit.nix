{
  config,
  inputs,
  globals,
  pkgs,
  ...
}:
let
  lazygitWrapper = pkgs.writeScriptBin "lazygit" ''
     #!/usr/bin/env bash
    LG_CONFIG_FILE="${config.xdg.configHome}/lazygit/config.yml,${config.xdg.configHome}/lazygit/theme.yml" ${pkgs.lazygit}/bin/lazygit "$@" 
  '';
in
{
  home = {
    shellAliases = {
      lg = ''lazygit "$@"'';
    };
  };

  programs.lazygit = {
    enable = true;
    package = lazygitWrapper;
    settings = {
      git = {
        autofetch = false;
        pagers = [
          {
            pager = "delta --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";
            colorArg = "always";
          }
        ];
      };
    };
  };

  xdg.configFile = {
    "lazygit/theme.yml".source =
      "${inputs.catppuccin-lazygit}/themes-mergable/${globals.theme.colors.flavour}/mauve.yml";
  };
}
