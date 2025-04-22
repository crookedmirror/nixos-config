_final: prev: {
  scripts = {
    nvidia-offload = _final.callPackage ./nvidia-offload.nix { };    
  };
}
