{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let
  cfg = config.module.dev.nixlang;
in {
  options.module.dev.nixlang= {
    enable = mkEnableOption "Nixlang module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nixfmt
      nurl
      rnix-lsp
      statix
    ];
  };
}

