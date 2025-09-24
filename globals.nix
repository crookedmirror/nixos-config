{ inputs, globals, ... }:
{
  imports = [
    (builtins.extraBuiltins.rageImportEncrypted inputs.self.secretsConfig.masterIdentities ./secrets/globals.nix.age)
  ];

  # Override globals
  # globals.theme.preferDark = false;
  # globals.myuser.name = "crookedmirror";
}
