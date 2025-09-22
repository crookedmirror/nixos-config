{
  globals,
  lib,
  pkgs,
  ...
}:
let
  # https://github.com/catppuccin/skim
  catppuccinLatteColors = "fg:#4c4f69,bg:#eff1f5,matched:#ccd0da,matched_bg:#dd7878,current:#4c4f69,current_bg:#bcc0cc,current_match:#eff1f5,current_match_bg:#dc8a78,spinner:#40a02b,info:#8839ef,prompt:#1e66f5,cursor:#d20f39,selected:#e64553,header:#179299,border:#9ca0b0";
  catppuccinMochaColors = "fg:#cdd6f4,bg:#1e1e2e,matched:#313244,matched_bg:#f2cdcd,current:#cdd6f4,current_bg:#45475a,current_match:#1e1e2e,current_match_bg:#f5e0dc,spinner:#a6e3a1,info:#cba6f7,prompt:#89b4fa,cursor:#f38ba8,selected:#eba0ac,header:#94e2d5,border:#6c7086";
  catppuccinColors =
    if globals.theme.preferDark then catppuccinMochaColors else catppuccinLatteColors;
  skimWrapper = pkgs.writeScriptBin "sk" ''
    #!/usr/bin/env bash
    SKIM_DEFAULT_OPTIONS="$SKIM_DEFAULT_OPTIONS --color ${catppuccinColors}" ${pkgs.skim}/bin/sk "$@" 
  '';
in
{
  programs.zsh.initContent = lib.mkOrder 550 ''
    export HISTDB_COLOR=--color=${catppuccinColors};
  '';

  programs.skim = {
    enable = true;
    enableZshIntegration = false;
    package = skimWrapper;
  };
}
