{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let
  cfg = config.module.obsidian;
  wrapper = pkgs.writeShellScriptBin "obsidian" ''
    unshare -n -r ${pkgs.obsidian}/bin/obsidian --no-sandbox "$@"
  '';
in {
  options.module.obsidian = {
    enable = mkEnableOption "Obsidian module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wrapper
    ];

    xdg.desktopEntries.obsidian = {
      name = "Obsidian";
      # genericName = "test";
      exec = "${wrapper}/bin/obsidian";
      terminal = false;
      categories = ["Application"];
      mimeType = [];
    };
  };
}

