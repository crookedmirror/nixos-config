# Forked from https://github.com/oddlama/nix-config/blob/main/nix/globals.nix
{ inputs, ... }:
{
  flake =
    {
      lib,
      ...
    }:
    {
      globals =
        let
          globalsSystem = lib.evalModules {
            prefix = [ "globals" ];
            specialArgs = {
              inherit inputs;
            };
            modules = [
              ../modules/globals.nix
              ../globals.nix
            ];
          };
        in
        {
          inherit (globalsSystem.config.globals)
            myuser
            theme
            ;
        };
    };

}
