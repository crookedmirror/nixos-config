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

    dwl-source = {
      url = "https://codeberg.org/dwl/dwl/archive/v0.7.zip";
      flake = false;
    };

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
      dwl-source,
      ...
    }@inputs:
    rec {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      nixosConfigurations = {
        dellvis = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos/configurations/dellvis/configuration.nix
            chaotic.nixosModules.default
                ];
        };
      
        jarvis = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos/configurations/jarvis/configuration.nix
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
        "crookedmirror@jarvis" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = {
            inherit inputs;
          };
          pkgs = nixpkgs.legacyPackages."x86_64-linux";

          modules = [
            ./home/users/crookedmirror_jarvis.nix
            chaotic.homeManagerModules.default
            nur.modules.homeManager.default
          ];
        };
      };
    };
}
