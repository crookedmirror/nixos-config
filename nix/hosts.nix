{ inputs, ... }:
{
  flake =
    {
      config,
      lib,
      ...
    }:
    let
      mkHost =
        name:
        let
          pkgs = config.pkgs.x86_64-linux; # FIXME: parametrize architecture
        in
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = (import ../pkgs/default.nix inputs) ++ [];
            }
            ../hosts/${name}
          ];
        };

      hosts = builtins.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir ../hosts));
    in
    {
      nixosConfigurations = lib.genAttrs hosts (mkHost);
    };
}
