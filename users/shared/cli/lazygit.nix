{
  config,
  inputs,
  globals,
  pkgs,
  ...
}:
let
  lgToDeltaFix = if globals.theme.preferDark then "--dark" else "--light";
  deltaWrapper = pkgs.writeScriptBin "delta" ''
    #!/usr/bin/env bash 
    DELTA_FEATURES="+catppuccin-${globals.theme.colors.flavour}" ${pkgs.delta}/bin/delta "$@" 
  '';
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

  programs.git = {

    delta = {
      enable = true;
      package = deltaWrapper;
      options = {
        features = "side-by-side";
        file-modified-label = "modified:";
      };
    };

    includes = [ { path = "${inputs.catppuccin-delta}/catppuccin.gitconfig"; } ];
  };

  programs.lazygit = {
    enable = true;
    package = lazygitWrapper;
    settings = {
      git = {
        autofetch = false;
        paging = {
          pager = ''
            	    delta --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}";
            	  '';
        };
      };
    };
  };

  xdg.configFile = {
    "lazygit/theme.yml".source =
      "${inputs.catppuccin-lazygit}/themes-mergable/${globals.theme.colors.flavour}/mauve.yml";
  };
}
