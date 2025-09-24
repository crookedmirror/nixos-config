# This module exposes pkgs for debugging outside of evaluation
# Ex: nix run .#pkgs.x86_64-linux.zsh-histdb-skim will test
# packages/zsh-histdb-skim.nix
{ inputs, ... }:
{
  imports = [
    (
      {
        lib,
        flake-parts-lib,
        ...
      }:
      flake-parts-lib.mkTransposedPerSystemModule {
        name = "pkgs";
        file = ./pkgs.nix;
        option = lib.mkOption {
          type = lib.types.unspecified;
        };
      }
    )
  ];
  perSystem =
    {
      pkgs,
      system,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ (import ../packages/default.nix) ];
      };

      inherit pkgs;
    };
}
