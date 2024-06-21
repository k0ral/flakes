{ config, pkgs ? import <nixpkgs> { }, ... }:

{
  home.packages = with pkgs; [
    croc
    logseq
    obsidian
    shiori
    thunderbird
    yewtube
  ];

  module.apps.ferdium.enable = true;
  module.apps.s.enable = true;

  programs.yt-dlp.enable = true;
}
