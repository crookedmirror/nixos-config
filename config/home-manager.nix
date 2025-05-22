{ inputs, config, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;

    sharedModules = [
      inputs.spicetify-nix.homeManagerModules.default
    ];

    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "backup";
    verbose = true;
  };

}
