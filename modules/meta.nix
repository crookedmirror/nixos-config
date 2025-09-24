{ lib, ... }:
let
  inherit (lib)
    mkOption
    types
    ;
in
{
  options.node.secretsDir = mkOption {
    description = "Path to the secrets directory for this node.";
    type = types.path;
  };
  options.node.name = mkOption {
    description = "Name of the node.";
    type = types.str;
  };
}
