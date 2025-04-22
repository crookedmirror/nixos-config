{ inputs, ... }:
{
  imports = [

    inputs.chaotic.nixosModules.default
    inputs.home-manager.nixosModules.default

    ./boot.nix
    ./home-manager.nix
    ./sound.nix
    ./net.nix
    ./nix.nix
    ./system.nix
  ];
}
