{
  pkgs,
  lib,
  globals,
  ...
}:
{
  home.packages = with pkgs; [
    opencode
    bun # Required for OpenCode's plugin system
    ast-grep # Required by oh-my-opencode
  ];

  xdg.configFile = {
    "opencode/opencode.json".source =
      lib._custom.relativeSymlink globals.myuser.configDirectory ./opencode.json;

    "opencode/oh-my-opencode.json".source =
      lib._custom.relativeSymlink globals.myuser.configDirectory ./oh-my-opencode.json;
  };
}
