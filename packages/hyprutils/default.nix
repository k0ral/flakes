{ lib
, stdenv
, makeWrapper
, fzf
, hyprland
, nushell
}:

stdenv.mkDerivation rec {
  pname = "hyprutils";
  version = "1.0.0";
  src = ./.;

  dontConfigure = true;
  dontBuild = true;

  buildInputs = [ fzf nushell hyprland ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -D output-enable.nu $out/bin/ihyprctl-output-enable
    wrapProgram $out/bin/ihyprctl-output-enable --prefix PATH : ${lib.makeBinPath [ fzf nushell hyprland ]}
    install -D output-disable.nu $out/bin/ihyprctl-output-disable
    wrapProgram $out/bin/ihyprctl-output-disable --prefix PATH : ${lib.makeBinPath [ fzf nushell hyprland ]}
  '';

  meta = with lib; {
    description = "Hyprland utility scripts";
    maintainers = with maintainers; [ koral ];
    platforms = platforms.linux;
  };
}
