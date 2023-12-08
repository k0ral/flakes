{ config, pkgs ? import <nixpkgs> { }, ... }:

{
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

  module.audio.beets = {
    enable = true;
    directory = "/home/music";
  };

  services.easyeffects.enable = true;

  xdg.configFile = {
    "cmus/rc".text = ''
      set replaygain=disabled
    '';
  };
}
