{ pkgs, ... }:
let
  python = pkgs.python312.withPackages (
    ps: with ps; [
      uv
      pip

      poetry-core
      requests
      python-dotenv
      pydantic
      pillow
      ollama
      tabulate
    ]
  );
in
{
  home.packages = [
    python
    pkgs.poetry
  ];
}
