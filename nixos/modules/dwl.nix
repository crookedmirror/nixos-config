{ pkgs, dwl-source, ... }:
pkgs.dwl.overrideAttrs
  (finalAttrs: previousAttrs: {
    src = dwl-source;
    postPatch =
      let
        configFile = ../../assets/dwl-config.h;
      in
      ''
        cp ${configFile} config.def.h
      '';
  })

