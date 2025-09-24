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
rec {
  nonNixos.enable = true;

  repo.secretFiles.user-myuser = ./secrets/user.nix.age;
  age.secrets.ssh-keys = {
    rekeyFile = ./secrets/ssh-keys.tar.age;
    mode = "640";
  };

  # Only needed for home.activation.agenix / Not needed for NixOs
  # age.identityPaths = [ "${config.home.homeDirectory}/.ssh/host" ];

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

      # Hack to make agenix secrets work with home-manager
      #agenix = lib.hm.dag.entryAnywhere config.systemd.user.services.agenix.Service.ExecStart;
      #installSshKeys = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      #  run cd /run/user/1000/agenix.d/* && ${lib.getExe pkgs.gnutar} xvf ssh-keys -C "$HOME/.ssh/"
      #'';
    };
  };
}
