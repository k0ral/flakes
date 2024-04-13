{ config, lib, pkgs ? import <nixpkgs> { }, ... }:

{
  module.cli.nushell.enable = true;
  module.cli.foot = {
    enable = true;
    shell = "nu --no-history";
  };

  xdg.configFile."navi/cheats" = {
    source = ./navi;
    recursive = true;
  };
}
