{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg.configFile."tor/torrc" = {
    text = ''
      #ExitNodes {ch}
      StrictNodes 1

      AvoidDiskWrites 1

      ClientTransportPlugin obfs4 exec ${pkgs.obfs4}/bin/lyrebird

      GeoIPFile ${pkgs.tor-browser}/share/tor-browser/TorBrowser/Data/Tor/geoip
      GeoIPv6File ${pkgs.tor-browser}/share/tor-browser/TorBrowser/Data/Tor/geoip6

      UseBridges 1
      Bridge obfs4 79.231.119.238:8080 3A76222696BA38823C43521FD604189A285D9859 cert=+xdVk09QmI7rY//B/hkW4PfdKyo4B7gEquHExKYfQCfWfFjkW0+bbj6NqBdoc0elJPvpKQ iat-mode=0
      Bridge obfs4 185.177.207.5:50528 E470A8AA45899B68F9882275838299C0114E02E9 cert=p9L6+25s8bnfkye1ZxFeAE4mAGY7DH4Gaj7dxngIIzP9BtqrHHwZXdjMK0RVIQ34C7aqZw iat-mode=2
      Bridge obfs4 49.13.126.113:17521 547A3A858B92D28C584FD0DA3B1E932467B244BA cert=j5iBsig0Q0FWbyzOBRAcqoO3vZ6FSgvfsYV2Fv3sDBlkA6lrzsu5G4NNcZJWnsa8HXC9cg iat-mode=0
      Bridge obfs4 95.217.11.29:22134 9859875C752128125D3179F90BA6351744B09040 cert=W+qSHr6JcFY6UyJiXR3Ec5I5bYHFwDAXNq8HRQU3C56h/aJB8PQqbr8Sq04zKvhEWGbxEw iat-mode=0
      # Bridge obfs4 92.252.94.252:8080 02F00A33017A24E99112E5CA498AECD204F913F3 cert=eWfCYOE/3kdmDpYy/tT0CuKI01dWKY6BtSAMSu0uuD4ixo7RE4/av+0fNjw4sbZmORLKVQ iat-mode=0
      # Bridge obfs4 185.177.207.204:11204 B6937CCDFFE05546B607A12003DA69F8136DD94F cert=ZRe3CHqlwsiJXeKVbLkpM3kAAo+JQQw0sHJBoGBjv2KDI2iibvPNoSanIjVYlqDuxntzNg iat-mode=1
      # Bridge obfs4 57.128.57.245:3099 D655AC9C21147BB62C781149150F0E723C4F8FBC cert=fnU2eGPmE6L53eXZf/29d1JloUD2XI/4KHNImTquPr/eBvkrOuuutIlpwvJsZTV1NvZ4aw iat-mode=0
      # Bridge obfs4 46.226.107.235:57180 93BD2E597D164D9FE9C74BF3E0F68531AC17EFB2 cert=lkV0hpUCIEEpU1nIFGnBJoabeXn0BFykm3NIf4an09Kq8nTK+qv6Z3A1i3Rkkc3hGMoqSA iat-mode=0
      # Bridge obfs4 89.245.61.249:49152 86A8801C84255EC714EF2AD4E4E665598800ABEF cert=8RNrsuwoQ64SLAKW920a64pjS9reyzhn6q3K3iYZc4ij21r8k8vVGRFpcNlsB+51VJR7Lw iat-mode=0
      # Bridge obfs4 185.177.207.78:12386 48B8D1B212B7C9EAC71C716892FF36E53C76D826 cert=p9L6+25s8bnfkye1ZxFeAE4mAGY7DH4Gaj7dxngIIzP9BtqrHHwZXdjMK0RVIQ34C7aqZw iat-mode=2
      # Bridge obfs4 51.38.220.224:30996 22494A012CFA8C88B1D907E2CCB8409AC35B537B cert=dOPijSCG6FD89fYv5N2F9QoeK1od3tpG6VBE/kMY0Bt1aW/7aXPIzsENDoLWZe43gI8efw iat-mode=0
      # Bridge obfs4 57.128.59.134:24102 A4AE24E2BF9CCD542A9F2794D534D13A39F2F161 cert=dX8/pc880Ne2bMEfmw75yFmsbnoZ+rWl4NDIjrei/ADZ/nHAiYTUw2HodxTIW8cWaKEkKQ iat-mode=0

      SocksPort 9050

      ControlPort 9051
      CookieAuthentication 0

      Sandbox 0
    '';
  };

  home.packages = with pkgs; [
    tor
    obfs4
    nyx
    proxychains
    tor-browser

    (pkgs.writeShellScriptBin "tor-start" ''
      ${pkgs.tor}/bin/tor -f ${config.xdg.configHome}/tor/torrc                                                                                                                                                                                                                             
    '')
    (pkgs.writeShellScriptBin "tor-stop" ''
      pkill -x tor                                                                                                                            
    '')
    (pkgs.writeShellScriptBin "tor-status" ''
      if pgrep -x tor > /dev/null; then                                                                                                       
        echo "Tor is running (PID: $(pgrep -x tor))"                                                                                          
        ${pkgs.nyx}/bin/nyx                                                                                                                   
      else                                                                                                                                    
        echo "Tor is not running"                                                                                                             
      fi                                                                                                                                      
    '')
  ];
}
