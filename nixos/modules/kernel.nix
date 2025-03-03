{ lib, pkgs, ... }: {

	environment.systemPackages = with pkgs; [ vulkan-caps-viewer vulkanPackages_latest.vulkan-tools ];

	boot.kernelParams = [ "intel_iommu=on" "nouveau.config=NvGspRm=1" "nouveau.debug=\"GSP=debug\"" ];
	boot.initrd.kernelModules = [ "nouveau" ];

	hardware.graphics = {
		enable = true;
		enable32Bit = true;
		extraPackages = with pkgs; [ intel-media-driver ];
	};
	
	chaotic.mesa-git = {
		enable = true;
		fallbackSpecialisation = false;
		extraPackages = with pkgs; [ intel-media-driver ];
	};

	boot.kernelPackages = lib.mkOverride 99 pkgs.linuxPackages_cachyos;
	
	specialisation.safe.configuration = {
		system.nixos.tags = [ "lts" ];
		boot.kernelPackages = lib.mkOverride 98 pkgs.linuxPackages;
	};
}
