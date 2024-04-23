{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let
  cfg = config.module.apps.ferdium;
in {
  options.module.apps.ferdium = {
    enable = mkEnableOption "Ferdium module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
        ferdium
    ];

    xdg.desktopEntries.ferdium = {
      name = "Ferdium";
      exec = "${pkgs.ferdium}/bin/ferdium";
      terminal = false;
      categories = ["Application" "Chat"];
      mimeType = [];
    };
  };
}
