{ config, lib, pkgs ? import <nixpkgs> { }, ... }:

{
  module.cli.fish.enable = true;
  module.cli.foot = {
    enable = true;
    shell = "fish --private";
  };

  xdg.configFile."navi/cheats" = {
    source = ./navi;
    recursive = true;
  };
}
