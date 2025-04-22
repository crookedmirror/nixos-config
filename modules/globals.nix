{  
  lib,
  options,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    ;
in
{
  options = {
    globals = mkOption {
      default = { };
      type = types.submodule {
        options = {
          root = {
            hashedPassword = mkOption {
              type = types.str;
              description = "My root user's password hash.";
            };
          };

          myuser = {
            name = mkOption {
              type = types.str;
              description = "My unix username.";
            };
            hashedPassword = mkOption {
              type = types.str;
              description = "My unix password hash.";
            };
          };

        };
      };
    };
  };
}
