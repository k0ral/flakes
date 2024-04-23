{ lib
, stdenv
, makeWrapper
, aria2
, httpie
, jq
, nushell
, swaybg
, yq
}:

stdenv.mkDerivation rec {
  pname = "wallit";
  version = "2.0.0";
  src = ./.;

  dontConfigure = true;
  dontBuild = true;

  buildInputs = [ aria2 httpie jq nushell swaybg yq ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -D wallit.nu $out/bin/wallit
    wrapProgram $out/bin/wallit --prefix PATH : ${lib.makeBinPath buildInputs}
  '';

  meta = with lib; {
    description = "Set random wallpaper";
    maintainers = with maintainers; [ koral ];
    platforms = platforms.linux;
  };
}
