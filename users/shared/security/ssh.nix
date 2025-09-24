{ config, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    inherit (config.userSecrets.ssh) matchBlocks;
  };
}
