{
  pkgs,
  globals,
  inputs,
  ...
}:
let
  deltaWrapper = pkgs.writeScriptBin "delta" ''
    #!/usr/bin/env bash 
    DELTA_FEATURES="+catppuccin-${globals.theme.colors.flavour}" ${pkgs.delta}/bin/delta "$@" 
  '';
in
{
  programs.git = {
    enable = true;
    extraConfig = {
      push.autoSetupRemote = true;
      pull.rebase = true;
      init.defaultBranch = "main";
    };

    aliases = {
      unstash = "stash pop";
      s = "status";
      tags = "tag -l";
    };

    delta = {
      enable = true;
      package = deltaWrapper;
      options = {
        features = "side-by-side";
        file-modified-label = "modified:";
      };
    };

    includes = [
      { path = "${inputs.catppuccin-delta}/catppuccin.gitconfig"; }
      {
        condition = "hasconfig:remote.*.url:**github.com:crookedmirror*/*.git";
        contents = {
          user = {
            email = "crookedmirror@xyz";
            name = "crookedmirror";
            identityFile = "github";
          };
        };
      }
    ];

  };
}
