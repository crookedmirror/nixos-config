{
  description = "crookedmirror's NixOS Flake";

  inputs = {
    # Upstream packages
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nur.url = "github:nix-community/NUR";

    nixpkgs.follows = "chaotic/nixpkgs";
    home-manager.follows = "chaotic/home-manager";

    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
    agenix.url = "github:ryantm/agenix";
    agenix-rekey.url = "github:oddlama/agenix-rekey";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    nixgl.url = "github:nix-community/nixGL";

    opcode.url = "github:getmissionctrl/claudia";

    spicetify.url = "github:Gerg-L/spicetify-nix";
    ayugram-desktop.url = "github:ndfined-crp/ayugram-desktop/release";

    #Themes
    catppuccin-zsh-fsh = {
      url = "github:catppuccin/zsh-fsh";
      flake = false;
    };
    catppuccin-eza = {
      url = "github:catppuccin/eza";
      flake = false;
    };
    catppuccin-bat = {
      url = "github:catppuccin/bat";
      flake = false;
    };
    catppuccin-lazygit = {
      url = "github:catppuccin/lazygit";
      flake = false;
    };
    catppuccin-delta = {
      url = "github:catppuccin/delta";
      flake = false;
    };
    catppuccin-alacritty = {
      url = "github:catppuccin/alacritty";
      flake = false;
    };
    catppuccin-dircolors = {
      url = "github:wochap/dircolors";
      flake = false;
    };
    catppuccin-tmux = {
      url = "github:catppuccin/tmux";
      flake = false;
    };
    phoenix = {
      url = "git+https://gitlab.com/celenityy/Phoenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mdatp.url = "github:NitorCreations/nix-mdatp";

  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake
      {
        inherit inputs;
      }
      {
        imports = [
          ./flake/agenix-rekey.nix
          ./flake/devshell.nix
          ./flake/globals.nix
          ./flake/pkgs.nix
          ./flake/hosts.nix
          ./flake/home-configurations.nix
        ];
        systems = [
          "x86_64-linux"
        ];
      };
}
