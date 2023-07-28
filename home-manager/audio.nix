{ config, pkgs ? import <nixpkgs> { }, ... }:

{
  imports = [ ./beets.nix ];

  home.packages = with pkgs; [
    chromaprint
    cmus
    mpc_cli
    qpwgraph
  ];

  module.audio.ncmpcpp = {
    enable = true;
    mpdMusicDir = "/home/music";
  };

  services.easyeffects.enable = true;

  xdg.configFile = {
    "cmus/rc".text = ''
      set replaygain=disabled
    '';
  };
}
