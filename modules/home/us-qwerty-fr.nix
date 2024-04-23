{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let cfg = config.module.hardware.us-qwerty-fr;
in {
  options.module.hardware.us-qwerty-fr = {
    enable = mkEnableOption "US-QWERTY-FR module";
  };

  config = mkIf cfg.enable {
    xdg.configFile."xkb/symbols/us_qwerty-fr".source = "${pkgs.qwerty-fr}/usr/share/X11/xkb/symbols/us_qwerty-fr";
  };
}
