{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    (if config.nonNixos.enable then (config.lib.nixGL.wrap zed-editor) else zed-editor)
  ];
}
