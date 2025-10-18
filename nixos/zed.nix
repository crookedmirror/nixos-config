{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zed-editor_git # chaotic
  ];
}
