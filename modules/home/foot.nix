{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let
  cfg = config.module.cli.foot;
in {
  options.module.cli.foot = {
    enable = mkEnableOption "foot module";
    shell = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable {
    programs = {
      foot.enable = true;
      foot.settings = {
          main.shell = cfg.shell;
          main.font = "VictorMono Nerd Font:size=14";
          main.bold-text-in-bright = "yes";
          colors = {
            alpha = 0.90;
            background = "000022";
          };
      };
    };
  };
}
