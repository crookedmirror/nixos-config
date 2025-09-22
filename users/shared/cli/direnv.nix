{
  home.sessionVariables."DIRENV_LOG_FORMAT" = "";

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # https://github.com/direnv/direnv/pull/1475
  xdg.configFile."direnv/direnv.toml".text = "";
}
