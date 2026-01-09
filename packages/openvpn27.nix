{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  openssl,
  lzo,
  lz4,
  pam,
  libcap_ng,
  libnl,
  systemd,
  python3,
  pkcs11helper,
}:

stdenv.mkDerivation rec {
  pname = "openvpn";
  version = "2.7_rc4";

  src = fetchurl {
    url = "https://build.openvpn.net/downloads/releases/openvpn-${version}.tar.gz";
    hash = "sha256-H7aHapetdzHlOiMBq38gEJN+ZGmHeX/5wdFUW3CYJz0=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    lzo
    lz4
    libcap_ng
    pkcs11helper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pam
    libnl
    systemd
    python3
  ];

  configureFlags = [
    "--enable-pkcs11"
    "--enable-systemd"
    "--disable-static"
  ];

  meta = with lib; {
    description = "Robust and highly flexible tunneling application (2.7 RC4)";
    homepage = "https://openvpn.net/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    mainProgram = "openvpn";
  };
}
