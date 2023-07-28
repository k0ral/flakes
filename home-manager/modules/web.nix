{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let
  cfg = config.module.web;
in {
  imports = [ ./librewolf.nix ];

  options.module.web = {
    enable = mkEnableOption "Web module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ elinks firefox-wayland monolith nyx yewtube w3m ];
    home.sessionVariables.BROWSER = "librewolf";
    module.web.librewolf.enable = true;
    programs.yt-dlp.enable = true;
  };
}
