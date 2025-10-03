{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:

let
  username = "jarvis";
in
{
  nonNixos.enable = true;

  repo.secretFiles.user-myuser = ./secrets/user.nix.age;
  userSecretsName = "user-myuser";

  nixGL = {
    #https://github.com/nix-community/nixGL/issues/114#issuecomment-2741822320
    packages = import inputs.nixgl { inherit pkgs; };
  };

  imports = [
    ../shared
  ];

  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;
  xdg.enable = true;

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
    sessionVariables = {
      "OTEL_EXPORTER_OTLP_ENDPOINT" = config.userSecrets.otel.endpoint;
      "SNYK_TOKEN" = config.userSecrets.snyk.api_key;
    };

    activation = {
      make-zsh-default-shell = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        PATH="/usr/bin:/bin:$PATH"
        SHELL_PATH="${pkgs.zsh}/bin/zsh"
        if [[ $(getent passwd ${username}) != *"$SHELL_PATH" ]]; then
          echo "setting zsh as default shell (using chsh). password might be necessay."
          if ! grep -q $SHELL_PATH /etc/shells; then
            echo "adding zsh to /etc/shells"
            run echo "$SHELL_PATH" | sudo tee -a /etc/shells
          fi
          echo "running chsh to make zsh the default shell"
          run chsh -s $SHELL_PATH ${username}
          echo "zsh is now set as default shell !"
        fi
      '';
    };
  };
}
