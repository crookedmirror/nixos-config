{ pkgs, ... }: {
	nixpkgs.config.allowUnfree = true;

	home.packages = with pkgs; [
		
		# Privacy
		keepassxc
		feather
		tor-browser
	];

	imports = [
		./git.nix
		./bash.nix
		./librewolf.nix
	];
}
