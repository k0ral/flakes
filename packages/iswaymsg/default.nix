{ lib
, stdenv
, makeWrapper
, fzf
, nushell
, sway
}:

stdenv.mkDerivation rec {
  pname = "iswaymsg";
  version = "1.0.0";
  src = ./.;

  dontConfigure = true;
  dontBuild = true;

  buildInputs = [ fzf nushell sway ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -D output-enable.nu $out/bin/iswaymsg-output-enable
    wrapProgram $out/bin/iswaymsg-output-enable --prefix PATH : ${lib.makeBinPath [ fzf nushell sway ]}
    install -D output-disable.nu $out/bin/iswaymsg-output-disable
    wrapProgram $out/bin/iswaymsg-output-disable --prefix PATH : ${lib.makeBinPath [ fzf nushell sway ]}
    install -D goto.nu $out/bin/iswaymsg-goto
    wrapProgram $out/bin/iswaymsg-goto --prefix PATH : ${lib.makeBinPath [ fzf nushell sway ]}
  '';

  meta = with lib; {
    description = "Interactive wrappers around swaymsg";
    maintainers = with maintainers; [ koral ];
    platforms = platforms.linux;
  };
}
