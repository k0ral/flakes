{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let cfg = config.module.essential.bluetooth;
in {
  options.module.essential.bluetooth = {
    enable = mkEnableOption "Essential bluetooth tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bluez
      bluez-tools
      obexfs
    ];
  };
}
