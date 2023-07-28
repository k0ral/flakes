{ pkgs, ... }:
{
  statusbar-utils = pkgs.callPackage ./statusbar-utils.nix { };
  oauth2l = pkgs.callPackage ./oauth2l.nix { };
  qwerty-fr = pkgs.callPackage ./qwerty-fr.nix { };
}
