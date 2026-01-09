_final: prev: {
  zsh-histdb-skim = prev.callPackage ./zsh-histdb-skim.nix { };
  anime4k = _final.callPackage ./anime4k.nix { };
  openvpn27 = prev.callPackage ./openvpn27.nix { };
}
