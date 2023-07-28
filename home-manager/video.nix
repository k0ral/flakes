{ config, pkgs ? import <nixpkgs> { }, ... }:

{
  home.packages = with pkgs; [
    kooha
    losslesscut-bin
    mkvtoolnix-cli
    python3Packages.subliminal
  ];

  module.video.ffmpeg.enable = true;
  module.video.mpv.enable = true;
}
