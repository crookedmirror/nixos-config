{
	nixpkgs.config.allowUnfree = true;

	imports = [
		./git.nix
		./bash.nix
		./librewolf.nix
		#./hyprland
	];
}
