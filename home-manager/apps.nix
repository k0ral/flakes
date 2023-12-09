{ config, pkgs ? import <nixpkgs> { }, ... }:

{
  home.packages = with pkgs; [
    croc
    obsidian
    shiori
    thunderbird
  ];

  module.apps.ferdium.enable = true;
}
