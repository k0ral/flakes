{ pkgs, ... }:
{
  clipboard-utils = pkgs.callPackage ./clipboard-utils { };
  hyprutils = pkgs.callPackage ./hyprutils { };
  iswaymsg = pkgs.callPackage ./iswaymsg { };
  iudiskie = pkgs.callPackage ./iudiskie { };
  oauth2l = pkgs.callPackage ./oauth2l.nix { };
  quottit = import ./quottit { inherit pkgs; };
  qwerty-fr = pkgs.callPackage ./qwerty-fr.nix { };
  statusbar-utils = pkgs.callPackage ./statusbar-utils.nix { };
  wallit = import ./wallit { inherit pkgs; };
}
