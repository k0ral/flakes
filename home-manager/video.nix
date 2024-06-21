{ config, pkgs ? import <nixpkgs> { }, ... }:

{
  home.packages = with pkgs; [
    kooha
    losslesscut-bin
    mkvtoolnix-cli
  ];

  module.video.ffmpeg.enable = true;
  module.video.mpv.enable = true;
}
