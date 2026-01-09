# crookedmirror's NixOS Flake

A personal, reproducible NixOS configuration managed with **Nix Flakes** and **Home Manager**. This setup aims for a cohesive, aesthetic, and functional environment across multiple hosts.

## Features

- **Hosts**: `dellvis` (workstation), `testvm` (QEMU testing)
- **Theming**: Consistent **Catppuccin** theme across shell, editors, and UI
- **Development**: Configured environments for Python, Go, Lua, Nix, and Web
- **Tools**: Neovim, Tmux, Zsh, Foot, Lazygit, Opencode, Claude
- **Security**: Agenix for secrets, OpenVPN 2.7, Tor, OSINT suite
- **Extras**: Chaotic-nyx cache, Spicetify, custom packages

## Installation

### Generic Installation (Real Hardware)

1.  **Boot** into the NixOS installation media.
2.  **Clone** this repository:
    ```bash
    git clone https://github.com/crookedmirror/nixos-config /tmp/nixos-config
    cd /tmp/nixos-config
    ```
3.  **Format drives** using Disko (replace `hostname` with your target, e.g., `dellvis`):
    ```bash
    # WARNING: This will format the disk defined in the host's disko.nix!
    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./hosts/<hostname>/disko.nix
    ```
4.  **Install** the system:
    ```bash
    sudo nixos-install --flake .#<hostname> \
      --option 'extra-substituters' 'https://chaotic-nyx.cachix.org/' \
      --option extra-trusted-public-keys "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
    ```
5.  **Persist** the configuration:
    ```bash
    # Copy the config to the persistent storage partition
    mkdir -p /mnt/var/persistent
    cp -r /tmp/nixos-config /mnt/var/persistent/
    ```
6.  **Reboot** and finish setup:
    ```bash
    reboot
    # Login as root and set your user password
    passwd <your-username>
    ```

### Installation on QEMU VM (`testvm`)

1.  Create the qcow2 drive:
    ```bash
    qemu-img create -f qcow2 nixos.qcow2 100G
    ```

2.  Start the VM:
    *Note: Adjust paths for OVMF firmware and ISO as needed.*
    ```bash
    qemu-system-x86_64 \
      -enable-kvm \
      -M q35 \
      -m 8G \
      -smp 4 \
      -cpu host \
      -boot order=d,menu=on \
      -drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE_4M.fd \
      -drive if=pflash,format=raw,file=./testvm-OVMF_VARS.fd \
      -drive file=testvm.qcow2,if=none,id=drive0,format=qcow2 \
      -device virtio-blk-pci,drive=drive0,serial=testvm-main \
      -drive file=/path/to/nixos-minimal.iso,media=cdrom,readonly=on \
      -device virtio-net,netdev=nic \
      -netdev user,hostfwd=tcp::2224-:22,hostname=testvm,id=nic \
      -display gtk
    ```

3.  Set the password for the `nixos` user (live ISO user) to enable SSH from host:
    ```bash
    passwd
    ```

4.  From the host, SSH into the guest:
    ```bash
    ssh -p 2224 nixos@localhost
    ```

5.  Install the `testvm` configuration from within the guest:
    ```bash
    git clone https://github.com/crookedmirror/nixos-config
    sudo -i
    
    # Partition and format
    nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /home/nixos/nixos-config/hosts/testvm/disko.nix
    
    # Install with Chaotic Nyx cache
    nixos-install --flake /home/nixos/nixos-config#testvm \
      --option 'extra-substituters' 'https://chaotic-nyx.cachix.org/' \
      --option extra-trusted-public-keys "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="

    # Persist configuration
    cp -r /home/nixos/nixos-config /mnt/var/persistent

    reboot
    ```
