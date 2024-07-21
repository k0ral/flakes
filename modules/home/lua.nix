{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let
  cfg = config.module.dev.lua;
in {
  options.module.dev.lua = {
    enable = mkEnableOption "Lua module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      selene
      stylua
    ];
  };
}

