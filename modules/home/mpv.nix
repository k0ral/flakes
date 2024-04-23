{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let
  cfg = config.module.video.mpv;
in {
  options.module.video.mpv = {
    enable = mkEnableOption "mpv module";
  };

  config = mkIf cfg.enable {
    home.shellAliases.play = "mpv --hwdec=auto";
    home.shellAliases.splay = "mpv --no-audio";

    programs.mpv = {
      enable = true;
      config = {
        audio-display = false;
        keep-open = "always";
      };
      bindings = { F2 = ''af toggle "lavfi=[dynaudnorm=f=75:g=25:n=0:p=0.58]"''; };
    };
  };
}
