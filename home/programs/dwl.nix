{ config, pkgs, lib, inputs, ... }:
with lib;
let
  cfg = config.programs.dwl;
  dwlPackage = import ../../nixos/modules/dwl.nix { inherit pkgs; inherit (inputs) dwl-source; };
in
{
  options.programs.dwl = {
    enable = mkEnableOption "dwl";
    
    package = mkOption {
      type = types.package;
      default = dwlPackage;
    };
  };


  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };

}
