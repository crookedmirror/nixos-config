{ inputs, ... }:
{
  flake =
    {
      config,
      lib,
      ...
    }:
    let

      makeHomeConfiguration = inputs.home-manager.lib.homeManagerConfiguration rec {
        pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = {
          inherit inputs;
          inherit (config) globals;
          overlays = [
            (import ../packages/default.nix)
            inputs.claude-code.overlays.default
          ];
          lib = inputs.nixpkgs.lib.extend (
            final: prev: {
              hm = inputs.home-manager.lib.hm;
              _custom = import ../lib {
                inherit inputs;
                inherit lib;
                inherit pkgs;
              };
            }
          );
        };
        modules = [
          ../config/non-nix.nix
          ../config/secrets.nix
          ../modules/symlinks.nix
          ../modules/meta.nix
          ../modules/secrets.nix
          ../users/jarvis
          inputs.chaotic.homeManagerModules.default
          inputs.spicetify.homeManagerModules.default
          inputs.nur.modules.homeManager.default
          inputs.agenix.homeManagerModules.default
          inputs.agenix-rekey.homeManagerModules.default
          {
            node.name = "jarvis";
            node.secretsDir = ../users/jarvis/secrets;
          }
        ];
      };
    in
    {
      homeConfigurations."jarvis" = (makeHomeConfiguration);
      nodes = config.homeConfigurations;
    };
}
