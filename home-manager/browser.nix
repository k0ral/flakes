{ config, lib, pkgs ? import <nixpkgs> { }, ... }:

{
  home.packages = with pkgs; [ elinks firefox-wayland nyx w3m ];
  home.sessionVariables.BROWSER = "firefox";
}
