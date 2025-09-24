{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  # Define local repo secrets
  repo.secretFiles =
    let
      local = config.node.secretsDir + "/local.nix.age";
    in
    lib.optionalAttrs (lib.pathExists local) { inherit local; };

  # Setup secret rekeying parameters
  age.rekey = {
    inherit (inputs.self.secretsConfig)
      masterIdentities
      ;
    agePlugins = [ pkgs.age-plugin-tpm ];

    hostPubkey = config.node.secretsDir + "/host.pub";
    storageMode = "local";
    generatedSecretsDir = inputs.self.outPath + "/secrets/generated/${config.node.name}";
    localStorageDir = inputs.self.outPath + "/secrets/rekeyed/${config.node.name}";
  };
}
