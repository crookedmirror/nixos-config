{
  config,
  pkgs,
  lib,
  inputs,
  globals,
  ...
}:
let
  inherit (globals.myuser) configDirectory;
  inherit (lib._custom) relativeSymlink;

  fshPlugin = {
    name = "zsh-fast-syntax-highlighting";
    src = pkgs.zsh-fast-syntax-highlighting;
    file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
  };
  fshPluginTheme = pkgs.stdenvNoCC.mkDerivation {
    name = "fsh-theme";
    nativeBuildInputs = [ pkgs.zsh ];
    buildCommand = ''
      zsh << EOF
        source "${fshPlugin.src}/${fshPlugin.file}"
        FAST_WORK_DIR="$out"
        mkdir -p "$out"
        fast-theme "${inputs.catppuccin-zsh-fsh}/themes/catppuccin-${globals.theme.colors.flavour}.ini"
      EOF
    '';
  };
  historyPlugin = rec {
    name = "zsh-hist";
    # We fetch specific version, as versions after are broken
    src = pkgs.fetchFromGitHub {
      owner = "larkery";
      repo = "zsh-histdb";
      rev = "30797f0c50c31c8d8de32386970c5d480e5ab35d";
      hash = "sha256-PQIFF8kz+baqmZWiSr+wc4EleZ/KD8Y+lxW2NT35/bg=";
    };
  };
in
{
  home.packages = with pkgs; [
    sqlite-interactive
    zsh-completions
  ];
  home.sessionVariables = {
    "HISTDB_DEFAULT_TAB" = "Directory|Machine";
    "HISTDB_FILE" = "${config.xdg.dataHome}/zsh/history.db";
  };
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    history = {
      #path = "${config.xdg.dataHome}/zsh/history";
      save = 1000500;
      size = 1000000;
    };
    enableCompletion = true;

    completionInit = ''
      # Completion plugin
      setopt GLOB_DOTS # show dotfiles in completion menus
      zstyle ':autocomplete:key-bindings' enabled no
      source ${pkgs.zsh-autocomplete}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
      source ${inputs.zsh-defer}/zsh-defer.plugin.zsh
    '';
    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # Powerlevel10k instant prompt.
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi                       
      '')
      (lib.mkOrder 550 ''
        [[ ! -f ${config.xdg.configHome}/zsh/.p10k.zsh ]] || source ${config.xdg.configHome}/zsh/.p10k.zsh
        # Theme
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      '')
      ''
        source ${historyPlugin.src}/sqlite-history.zsh
        source ${relativeSymlink configDirectory ./config/config.zsh}
        source ${relativeSymlink configDirectory ./config/functions.zsh}

        # Syntax highlighting
        zle_highlight=('paste:fg=white,bold') # Remove background from pasted text
        FAST_WORK_DIR="${fshPluginTheme}"
        source ${fshPlugin.src}/${fshPlugin.file}

        # History reverse search
        source ${pkgs.zsh-histdb-skim}/share/zsh-histdb-skim/zsh-histdb-skim.plugin.zsh
        # FIXME: only shell.nix and eza.nix shellAliases are displayed
        source ${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/aliases/aliases.plugin.zsh
        # ZSH in Nix-Shell
        source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

        source ${relativeSymlink configDirectory ./config/key-bindings.zsh}
      ''
    ];
  };

  xdg.configFile = {
    "zsh/.p10k.zsh".source = relativeSymlink configDirectory ./config/.p10k.zsh;
  };
}
