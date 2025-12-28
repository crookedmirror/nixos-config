{ lib, pkgs, ... }:
let
  python-final = pkgs.python314.withPackages (
    ps: with ps; [
      #uv
    ]
  );
in
{
  home.packages = with pkgs; [
    python-final

    # Python tools
    pipx
    pipenv
    poetry
    uv
  ];

  # adds ~/.local/bin folder to the PATH env var
  home.sessionPath = [ "$HOME/.local/bin" ];

  # env variable to be used within neovim config
  # NOTE: this variable changes every time you update Python pkgs
  # you may need to log out and log back in for changes to take effect
  home.sessionVariables.GLOBAL_PYTHON_FOLDER_PATH = "${python-final}";

  # HACK: Make global modules available in python
  programs.zsh.initContent = lib.mkOrder 999 ''
    if [ -d "$HOME/.venv" ]; then
      zsh-defer source "$HOME/.venv/bin/activate"
    else
      ${python-final}/bin/python -m venv "$HOME/.venv"
    fi
  '';

}
