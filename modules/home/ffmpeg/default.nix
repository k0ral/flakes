{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let
  cfg = config.module.video.ffmpeg;
  concat = pkgs.writeScriptBin "concat" (builtins.readFile ./concat.sh);
  cut-from-to = pkgs.writeScriptBin "cut-from-to" (builtins.readFile ./cut-from-to.sh);
  cut-from = pkgs.writeScriptBin "cut-from" (builtins.readFile ./cut-from.sh);
  cut-to = pkgs.writeScriptBin "cut-to" (builtins.readFile ./cut-to.sh);
in {
  options.module.video.ffmpeg = {
    enable = mkEnableOption "FFmpeg module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ffmpeg

      # Aliases
      concat
      cut-from-to
      cut-from
      cut-to
    ];

    home.shellAliases.ffprobe = "${pkgs.ffmpeg}/bin/ffprobe -hide_banner";
  };
}
