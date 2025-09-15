{
  flake = {
    secretsConfig = {
      masterIdentities = [
        ../secrets/jarvis-nix-rage.pub
        ../secrets/dellvis-nix-rage.pub
      ];
    };
  };
}
