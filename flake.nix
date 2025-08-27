{
  description = "crookedmirror's NixOS Flake";

  inputs = {
    nixpkgs.follows = "chaotic/nixpkgs";

    home-manager.follows = "chaotic/home-manager";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nur.url = "github:nix-community/NUR";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    ayugram-desktop.url = "github:ndfined-crp/ayugram-desktop/release";

    dwl-source = {
      url = "https://codeberg.org/dwl/dwl/archive/v0.7.zip";
      flake = false;
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
    
    phoenix = {
      url = "git+https://gitlab.com/celenityy/Phoenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mdatp.url = "github:NitorCreations/nix-mdatp";

  };
 outputs =
   inputs:
   inputs.flake-parts.lib.mkFlake { inherit inputs; } {
     imports = [
       ./nix/devshell.nix
       ./nix/pkgs.nix
       ./nix/hosts.nix
     ];
     systems = [ "x86_64-linux" ];
    };
}
