{ stdenv, lib, fetchzip }:

stdenv.mkDerivation rec {
  pname = "qwerty-fr";
  version = "0.7.2";

  src = fetchzip {
    url = "https://github.com/qwerty-fr/${pname}/releases/download/v${version}/${pname}_${version}_linux.zip";
    sha256 = "sha256-ARTNVMyKa3C1a1XSxn+N63q4/6rfETkzRwF5Qv+Qhp0=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out
    mv usr $out/usr
  '';

  meta = with lib; {
    description = "Qwerty keyboard layout with French accents";
    homepage = "https://github.com/qwerty-fr/${pname}";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
