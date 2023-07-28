{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let cfg = config.module.wayland.fuzzel;
in {
  options.module.wayland.fuzzel = { enable = mkEnableOption "Fuzzel module"; };

  config = mkIf cfg.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main.font = "VictorMono Nerd Font:size=13";
        main.terminal = "foot";
        main.width = 80;
        colors.background = "000033dd";
        colors.text = "aaaaffff";
      };
    };
  };
}
