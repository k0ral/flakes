{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let cfg = config.module.nixos.ntfs;
in {
  options.module.nixos.ntfs = {
    enable = mkEnableOption "support for NTFS";
  };

  config = mkIf cfg.enable {
    boot.supportedFilesystems = [ "ntfs" ];

    environment.systemPackages = with pkgs; [
      ntfs3g
    ];
  };
}
