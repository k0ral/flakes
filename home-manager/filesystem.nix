{ config, pkgs ? import <nixpkgs> { }, ... }:

{
  home.packages = with pkgs; [
    dua
    ipfs
    iudiskie
    libnotify
    mergerfs
    udiskie
  ];

  home.shellAliases.du = "dua i";
}
