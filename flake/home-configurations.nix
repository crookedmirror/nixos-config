{ inputs, ... }:
{
  flake =
    {
      config,
      lib,
      system,
      ...
    }:
    let
      inherit (lib)
        concatMapAttrs
        filterAttrs
        flip
        genAttrs
        mapAttrs
        mapAttrs'
        nameValuePair
        ;

      makeHomeConfiguration = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";

        extraSpecialArgs = {
          inherit inputs;
          inherit (config) globals;
          overlays = [ (import ../packages/default.nix) ];
        };
        modules = [
          ../config/non-nix.nix
          ../config/secrets.nix
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
