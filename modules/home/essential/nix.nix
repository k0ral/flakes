{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let cfg = config.module.essential.nix;
in {
  options.module.essential.nix = {
    enable = mkEnableOption "Essential Nix tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cachix
      nix-tree
      nvd
    ];

    nixpkgs.config = {
      allowUnfreePredicate = (pkg: true);
    };

    programs.nix-index.enable = true;
  };
}
