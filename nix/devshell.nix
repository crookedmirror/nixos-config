{ inputs, ... }:
{
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem =
    {
      pkgs,
      ...
    }:
    {
        devshells.default = {
        packages = [
          pkgs.nix # Always use the nix version from this flake's nixpkgs version, so that nix-plugins (below) doesn't fail because of different nix versions.
        ];

        commands = [
          {
            package = pkgs.nix-output-monitor;
            help = "Nix Output Monitor (a drop-in alternative for `nix` which shows a build graph)";
          }
          {
            package = pkgs.writeShellApplication {
              name = "build";
              text = ''
                set -euo pipefail
                [[ "$#" -ge 1 ]] \
                  || { echo "usage: build <HOST>..." >&2; exit 1; }
                HOSTS=()
                for h in "$@"; do
                  HOSTS+=(".#nixosConfigurations.$h.config.system.build.toplevel")
                done
                nom build --no-link --print-out-paths --show-trace "''${HOSTS[@]}"
              '';
            };
            help = "Build a host configuration";
          }
        ];
      };
    };
}
