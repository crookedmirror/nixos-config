{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nonNixos;
in
{
  options.nonNixos = with lib; {
    enable = mkEnableOption "nonNixos";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      config.nix.package
    ];

    nix = {
      package = pkgs.nix;
    };
  };
}
