{
  inputs,
  pkgs,
  ...
}:
{
  imports = [

    ../../config

    ../../config/hardware/mesa.nix
    ../../config/hardware/intel.nix
    ../../config/hardware/ergohaven.nix
    ../../config/hardware/ni-audio-6.nix
    ../../config/graphical
    ../../config/amnezia.nix
    ../../users/crookedmirror

    ./fs.nix
    ./net.nix
    ./nixos
    inputs.mdatp.nixosModules.mdatp
  ];
  nixpkgs.hostPlatform = "x86_64-linux";

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  services.intune.enable = true;
  services.mdatp.enable = true;
  systemd.user.timers.intune-agent.wantedBy = [ "graphical-session.target" ];
  systemd.sockets.intune-daemon.wantedBy = [ "sockets.target" ];
  services.flatpak.enable = true;
  programs.direnv.enable = true;

  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
  security.tpm2.tctiEnvironment.enable = true; # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables

  #services.ollama.enable = true;
  #services.ollama.loadModels = [ "devstral" ];
  #services.nextjs-ollama-llm-ui.enable = true;
  #boot.supportedFilesystems = [ "ntfs" ];
  #fileSystems."/porsche" = {
  #  device = "/dev/disk/by-uuid/C88E64058E63EB00";
  #  fsType = "ntfs-3g";
  #  options = [
  #    "rw"
  #    "uid=1000"
  #  ];
  #};
  environment = {
    systemPackages = with pkgs; [
      vim
      git
      corectrl
    ];
  };
}
