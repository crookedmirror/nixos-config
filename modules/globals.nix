{
  lib,
  options,
  config,
  ...
}:
let
  inherit (config.globals.theme) themeColorsLight themeColorsDark preferDark;
  catppuccinLatteTheme = import ./catppuccin-latte.nix;
  catppuccinMochaTheme = import ./catppuccin-mocha.nix;
in
{
  options = {
    globals = lib.mkOption {
      type = lib.types.submodule {
        options = {
          myuser = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "my unix username.";
            };
          };
          theme = {
            preferDark = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Prefer dark theme";
            };
            colors = lib.mkOption {
              default = if preferDark then themeColorsDark else themeColorsLight;
              type = lib.types.attrsOf (lib.types.nullOr lib.types.str);
              description = "Theme colors";
            };
            themeColorsLight = lib.mkOption {
              type = lib.types.attrsOf (lib.types.nullOr lib.types.str);
              default = catppuccinLatteTheme;
              description = "Light System wide theme";
            };
            themeColorsDark = lib.mkOption {
              type = lib.types.attrsOf (lib.types.nullOr lib.types.str);
              default = catppuccinMochaTheme;
              description = "Dark system wide theme";
            };
          };
        };
      };
    };
  };
}
