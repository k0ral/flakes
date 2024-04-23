{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let
  cfg = config.module.dev.kubernetes;
in {
  options.module.dev.kubernetes = {
    enable = mkEnableOption "kubernetes module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ kubectl k9s ];

    xdg.configFile."navi/cheats/kubernetes.cheat".text = ''
      % kubernetes

      # Set context
      kubectl config use-context <context>

      $ context: kubectl config get-contexts
    '';
  };
}
