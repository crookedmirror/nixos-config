{ pkgs, ... }: {
	home = {
		username = "crookedmirror";
		homeDirectory = "/home/crookedmirror";
		stateVersion = "24.11";

	};
	nix.package = pkgs.nix;

	imports = [
		../programs
	];
	
	#programs.bash = {
	#	enable = true;
	#	shellAliases = 
	#	let 
	#		flakePath = "~/nix";
	#	in {
	#		rebuild = "sudo nixos-rebuild switch --flake ${flakePath}";
	#		hms = "home-manager switch --flake ${flakePath}";
	#	};
	#};
}
