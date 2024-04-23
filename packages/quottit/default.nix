{ lib
, stdenv
, makeWrapper
, httpie
, jq
, nushell
}:

stdenv.mkDerivation rec {
  pname = "quottit";
  version = "2.0.0";
  src = ./.;

  dontConfigure = true;
  dontBuild = true;

  buildInputs = [ httpie jq nushell ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -D quottit.nu $out/bin/quottit
    wrapProgram $out/bin/quottit --prefix PATH : ${lib.makeBinPath buildInputs}
  '';

  meta = with lib; {
    description = "Print a random quote";
    maintainers = with maintainers; [ koral ];
    platforms = platforms.linux;
  };
}
