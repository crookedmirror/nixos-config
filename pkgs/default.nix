_inputs: [
  (import ./scripts)
  (final: prev: {
    anime4k = final.callPackage ./anime4k.nix {};
    #nvidia-offload = final.callPackage ./scripts { scriptName = "nvidia-offload"; };
  })
]
