{ inputs, ... }:
{
  imports = [
    inputs.devshell.flakeModule
    inputs.pre-commit-hooks.flakeModule
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    {
      pre-commit.settings.hooks.treefmt.enable = true;
      treefmt = {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt.enable = true;
          shfmt.enable = true;
        };
      };

      devshells.default = {
        packages = [
          #Packages needed for decryption of repo.secrets
          pkgs.rage
          pkgs.age-plugin-tpm
        ];
        commands = [
          {
            package = config.treefmt.build.wrapper;
            help = "Format all files";
          }
          {
            package = pkgs.writeShellApplication {
              name = "hms";
              text = "home-manager switch -b backup --flake . --impure";
            };
            help = "Rebuild home-manager configuration";
          }
        ];
        devshell.startup.pre-commit.text = config.pre-commit.installationScript;
        devshell.startup.shell-hook.text = ''
          export NIX_CONFIG="
            plugin-files = ${
              pkgs.nix-plugins.overrideAttrs (o: {
                buildInputs = [
                  pkgs.nix # Match version of nix-plugins with the one used in this flake
                  pkgs.boost
                ];
              })
            }/lib/nix/plugins
            extra-builtins-file = ${./..}/nix/extra-builtins.nix
          "
        '';
      };
    };
}
