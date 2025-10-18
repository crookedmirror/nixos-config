{
  lib,
  config,
  overlays,
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

    nixpkgs = {
      config.allowUnfree = true;
      inherit overlays;
    };
  };
}
