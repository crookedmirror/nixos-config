{ lib, pkgs, ... }:
let
  python-final = pkgs.python311.withPackages (
    ps: with ps; [
      uv # pip replacement
      pip
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
  ];
}
