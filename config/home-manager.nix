{ inputs, config, ... }:
{
  home-manager = {
    sharedModules = [
      inputs.chaotic.homeManagerModules.default
      inputs.nur.modules.homeManager.default
      inputs.spicetify-nix.homeManagerModules.default
    ];

    extraSpecialArgs = { inherit inputs; };
  };
}
