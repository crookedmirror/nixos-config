{ pkgs, ... }: {
	programs.librewolf = {
		enable = true;
		settings = {
			"webgl.disabled" = true;
		};
		profiles.default.extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
			localcdn
			wappalyzer
			darkreader
			google-container
			pywalfox
			surfingkeys
		];
	};
}
