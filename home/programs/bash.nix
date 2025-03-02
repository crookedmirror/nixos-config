{ pkgs, ...}: {
	home.packages = [
		pkgs.bat
	];
	programs.bash = {
		enable = true;
		shellAliases = 
		let
			flakePath = "~/nix";
		in {
			rebuild = "sudo nixos-rebuild switch --flake ${flakePath}";
			hms = "home-manager switch --flake ${flakePath}";
			cat = "bat --paging=never";
		};
	};
}
