# https://github.com/PedroHLC/system-setup/blob/94e7a325bbf760c56fa2ae47608c2a2f41e4fb81/packages/scripts/default.nix
{
  scriptName,
  substitutions ? null,
  lib,
  stdenvNoCC,
  bash,
}:
let
  inherit (lib.strings) concatStringsSep escapeShellArg;
  inherit (lib.attrsets) mapAttrsToList;
  repArg = k: v: "--replace-fail ${escapeShellArg k} ${escapeShellArg v}";

  install =
    if substitutions != null then
      ''
        substitute "${scriptName}.sh" "$out/bin/${scriptName}" \
          ${concatStringsSep " " (mapAttrsToList repArg substitutions)}
      ''
    else
      ''
        cp "${scriptName}.sh" "$out/bin/${scriptName}"
      '';
in
stdenvNoCC.mkDerivation {
  name = scriptName;
  src = "${./.}";
  buildInputs = [ bash ];
  preferLocalBuild = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    ${install}
    chmod +x "$out/bin"/*
    patchShebangs "$out/bin"

    runHook postInstall
  '';
  checkPhase = ''
    runHook preCheck

    bash -n -O extglob "$out/bin"/*

    runHook postCheck
  '';
  meta.mainProgram = scriptName;
}
