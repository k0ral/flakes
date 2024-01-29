{ lib
, stdenv
, makeWrapper
, fzf
, jq
, nushell
, udiskie
}:

stdenv.mkDerivation rec {
  pname = "i-umount";
  version = "1.0.0";
  src = ./.;

  dontConfigure = true;
  dontBuild = true;

  buildInputs = [ fzf jq nushell udiskie ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -D run.nu $out/bin/i-umount
    wrapProgram $out/bin/i-umount --prefix PATH : ${lib.makeBinPath [ fzf jq nushell udiskie ]}
  '';

  meta = with lib; {
    description = "Interactively mount filesystems";
    maintainers = with maintainers; [ koral ];
    platforms = platforms.linux;
  };
}
