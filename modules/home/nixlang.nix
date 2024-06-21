{ config, lib, pkgs ? import <nixpkgs> { }, inputs, ... }:
with lib;

let
  cfg = config.module.dev.nixlang;
in {
  options.module.dev.nixlang= {
    enable = mkEnableOption "Nixlang module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nil
      nixfmt-classic
      (inputs.nix-search.packages.${pkgs.system}.nix-search)
      nurl
      statix
    ];
  };
}
