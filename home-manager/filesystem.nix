{ config, pkgs ? import <nixpkgs> { }, ... }:

{
  home.packages = with pkgs; [
    du-dust
    dua
    ipfs
    libnotify
    mergerfs
    udiskie
  ];

  home.shellAliases.du = "dust";
}
