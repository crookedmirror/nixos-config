{
  pkgs,
  lib,
  globals,
  ...
}:
{
  home.packages = with pkgs; [ claude-code ];

  home.file.".claude/settings.json".source =
    lib._custom.relativeSymlink globals.myuser.configDirectory ./settings.json;

  home.file.".claude/statusline.sh" = {
    source = ./statusline.sh;
    executable = true;
  };
}
