{ lib, pkgs, ... }: {
	boot.kernelPackages = lib.mkOverride 99 pkgs.linuxPackages_cachyos;
	
	specialisation.safe.configuration = {
		system.nixos.tags = [ "lts" ];
		boot.kernelPackages = lib.mkOverride 98 pkgs.linuxPackages;
	};
}
