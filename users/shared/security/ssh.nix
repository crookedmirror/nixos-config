{ config, inputs, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    inherit (config.userSecrets.ssh) matchBlocks;
    #matchBlocks = {
    #  "*" = {
    #    addKeysToAgent = "yes";
    #    controlMaster = "auto";
    #  };
    #  "github.com" = {
    #    hostname = "github.com";
    #    user = "git";
    #    identitiesOnly = true;
    #    identityFile = "${inputs.self.outPath}/id_ed25519";
    #  };
    #};
  };
}
