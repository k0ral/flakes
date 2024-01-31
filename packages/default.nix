{ pkgs, ... }:
{
  iswaymsg = pkgs.callPackage ./iswaymsg { };
  iudiskie = pkgs.callPackage ./iudiskie { };
  oauth2l = pkgs.callPackage ./oauth2l.nix { };
  qwerty-fr = pkgs.callPackage ./qwerty-fr.nix { };
  statusbar-utils = pkgs.callPackage ./statusbar-utils.nix { };
}
