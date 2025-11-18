{
  pkgs,
  config,
  inputs,
  ...
}:
{
  home.packages = [
    (
      if config.nonNixos.enable then
        (config.lib.nixGL.wrap inputs.ayugram-desktop.packages.${pkgs.system}.default)
      else
        inputs.ayugram-desktop.packages.${pkgs.system}.default
    )
  ];
}
