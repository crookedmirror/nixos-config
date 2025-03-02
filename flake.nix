{
	description = "crookedmirror's NixOS Flake";
	
	inputs = {
		nixpkgs.follows = "chaotic/nixpkgs";

		home-manager.follows = "chaotic/home-manager";
		
		chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
	};

	outputs = { nixpkgs, home-manager, chaotic, ... }@inputs:  {
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
				#extraSpecialArgs = {
				#	inherit inputs;
				#};
				pkgs = nixpkgs.legacyPackages."x86_64-linux";
				
				modules = [
					./home/users/crookedmirror_dellvis.nix
					chaotic.homeManagerModules.default
				];
			};
		};
	};
}
