{ lib
, stdenv
, makeWrapper
, nushell
, libnotify
, qrencode
}:

stdenv.mkDerivation rec {
  pname = "clipboard-utils";
  version = "1.0.0";
  src = ./.;

  dontConfigure = true;
  dontBuild = true;

  buildInputs = [ libnotify nushell qrencode ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -D notify.nu $out/bin/clipboard-notify
    wrapProgram $out/bin/clipboard-notify --prefix PATH : ${lib.makeBinPath [ nushell libnotify ]}

    install -D qrencode.nu $out/bin/clipboard-qrencode
    wrapProgram $out/bin/clipboard-qrencode --prefix PATH : ${lib.makeBinPath [ nushell qrencode ]}
  '';

  meta = with lib; {
    description = "Utilities related to clipboard.";
    maintainers = with maintainers; [ koral ];
    platforms = platforms.linux;
  };
}
