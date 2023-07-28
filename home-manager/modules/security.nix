{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let
  cfg = config.module.security;
in {
  options.module.security = {
    enable = mkEnableOption "Security module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pass
    ];

    programs.gpg.enable = true;
    services.gpg-agent.enable = true;
    services.gpg-agent.pinentryFlavor = "curses";
  };
}
