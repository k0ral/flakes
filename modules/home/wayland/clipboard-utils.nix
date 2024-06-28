{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let cfg = config.module.wayland.clipboard-utils;
in {
  options.module.wayland.clipboard-utils = {
    enable = mkEnableOption "clipboard-utils module";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.clipboard-utils ];

    xdg.desktopEntries = {
      clipboard-notify = {
        name = "Show clipboard content in notifications";
        exec = "clipboard-notify";
      };

      clipboard-qrencode = {
        name = "Show QR code with clipboard content";
        exec = "clipboard-qrencode";
      };
    };
  };
}
