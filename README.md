#Installing this flake

1) Load installation media
2) clone this repository:
  - git clone https://github.com/crookedmirror/nixos-config
3) Make nessesary adjustments (for ex. for virtual envs change the disk name to /dev/vda) and copy disko.nix to /tmp:
  - cd nixos-config
  - cp disko.nix /tmp
4) format drives using disko:
  - sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /tmp/disko.nix
5) Generate nixos config
  - sudo nixos-generate-config --root /mnt/
5) Adjust the disk uuids in hardware configuration that you want to use & copy nixos-config to /mnt
  - sudo cp -rf nixos-config /mnt/etc
6) sudo nixos-install --flake /mnt/etc/nixos-config#mymachine --option 'extra-substituters' 'https://chaotic-nyx.cachix.org/' --option extra-trusted-public-keys "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
7) reboot, login as root and set password for main user
