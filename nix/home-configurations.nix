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
        pkgs = import inputs.nixpkgs {
          config.allowUnfree = true;
          overlays = [ (import ../packages/default.nix) ];
        };

        extraSpecialArgs = {
          inherit inputs;
          inherit (config) globals;
        };
        modules = [
          ../home-manager/home.nix
          inputs.chaotic.homeManagerModules.default
          inputs.spicetify.homeManagerModules.default
          inputs.nur.modules.homeManager.default
        ];
      };
    in
    {
      homeConfigurations."crookedmirror" = (makeHomeConfiguration);
    };
}
