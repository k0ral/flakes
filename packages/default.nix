{ pkgs, ... }:
{
  clipboard-utils = pkgs.callPackage ./clipboard-utils { };
  hyprutils = pkgs.callPackage ./hyprutils { };
  iswaymsg = pkgs.callPackage ./iswaymsg { };
  iudiskie = pkgs.callPackage ./iudiskie { };
  oauth2l = pkgs.callPackage ./oauth2l.nix { };
  quottit = pkgs.callPackage ./quottit { };
  qwerty-fr = pkgs.callPackage ./qwerty-fr.nix { };
  s = pkgs.callPackage ./s.nix { };
  statusbar-utils = pkgs.callPackage ./statusbar-utils.nix { };
  wallit = pkgs.callPackage ./wallit { };
}
