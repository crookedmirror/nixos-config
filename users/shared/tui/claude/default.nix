{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [ claude-code ];

  home.file.".claude/settings.json".text = builtins.toJSON {
    alwaysThinkingEnabled = true;
    extraKnownMarketplaces = {
      "owt-marketplace" = {
        source = {
          source = "git";
          url = "git@github.com:openwt/OWTAIMarketplace.git";
        };
      };
    };
  };
}
