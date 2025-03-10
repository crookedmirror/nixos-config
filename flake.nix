{
  description = "crookedmirror's NixOS Flake";

  inputs = {
    nixpkgs.follows = "chaotic/nixpkgs";

    home-manager.follows = "chaotic/home-manager";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nur.url = "github:nix-community/NUR";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    grayjay.url = "github:rishabh5321/grayjay-flake";

    ayugram-desktop.url = "github:ndfined-crp/ayugram-desktop/release";
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      chaotic,
      nur,
      spicetify-nix,
      grayjay,
      ayugram-desktop,
      ...
    }@inputs:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      nixosConfigurations = {
        dellvis = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos/configurations/dellvis.nix
            chaotic.nixosModules.default
          ];
        };
      };
      homeConfigurations = {
        "crookedmirror@dellvis" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = {
            inherit inputs;
          };
          pkgs = nixpkgs.legacyPackages."x86_64-linux";

          modules = [
            ./home/users/crookedmirror_dellvis.nix
            chaotic.homeManagerModules.default
            nur.modules.homeManager.default
            spicetify-nix.homeManagerModules.default
          ];
        };
      };
    };
}
