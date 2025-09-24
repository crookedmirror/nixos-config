{
  inputs,
  self,
  ...
}:
{
  imports = [
    inputs.agenix-rekey.flakeModule
  ];

  flake = {
    # The identities that are used to rekey agenix secrets and to
    # decrypt all repository-wide secrets.
    secretsConfig = {
      masterIdentities = [
        {
          identity = ../secrets/jarvis-nix-rage.pub;
          pubkey = "age1tpm1qthur0dg6lhanph2gpgcnzuv07epumxxnw9ka3c7ltz2sr6nqhe9ksve7ct";
        }
        {
          identity = ../secrets/dellvis-nix-rage.pub;
          pubkey = "age1tpm1q2ggf943ppzwpqwcf39m0r3ztj3vzg6yap2e3tewda7m7k6k0cxdv70jqfk";
        }
      ];
    };
  };

  perSystem =
    { config, ... }:
    {
      agenix-rekey.nixosConfigurations = self.nodes;
      devshells.default = {
        commands = [
          {
            inherit (config.agenix-rekey) package;
            help = "Edit, generate and rekey secrets";
          }
        ];
        env = [
          {
            # Always add files to git after agenix rekey and agenix generate.
            name = "AGENIX_REKEY_ADD_TO_GIT";
            value = "true";
          }
        ];
      };
    };
}
