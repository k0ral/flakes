{ pkgs, ... }:
{
  i-umount = pkgs.callPackage ./i-umount { };
  oauth2l = pkgs.callPackage ./oauth2l.nix { };
  qwerty-fr = pkgs.callPackage ./qwerty-fr.nix { };
  statusbar-utils = pkgs.callPackage ./statusbar-utils.nix { };
}
