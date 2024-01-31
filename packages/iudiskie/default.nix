{ lib
, stdenv
, makeWrapper
, fzf
, jq
, nushell
, udiskie
}:

stdenv.mkDerivation rec {
  pname = "iudiskie";
  version = "1.0.0";
  src = ./.;

  dontConfigure = true;
  dontBuild = true;

  buildInputs = [ fzf jq nushell udiskie ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -D run.nu $out/bin/iudiskie-umount
    wrapProgram $out/bin/iudiskie-umount --prefix PATH : ${lib.makeBinPath [ fzf jq nushell udiskie ]}
  '';

  meta = with lib; {
    description = "Interactive wrapper around udiskie";
    maintainers = with maintainers; [ koral ];
    platforms = platforms.linux;
  };
}
