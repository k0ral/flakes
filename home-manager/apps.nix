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

  programs.yt-dlp.enable = true;
}
