{ config, pkgs ? import <nixpkgs> { }, ... }:

{
  module.cli.fish.enable = true;

  programs = {
    foot.enable = true;
    foot.settings = {
        main.shell = "fish --private";
        main.font = "VictorMono Nerd Font:size=14";
        main.bold-text-in-bright = "yes";
        colors = {
          alpha = 0.90;
          background = "000022";
        };
    };
  };

  xdg.configFile."navi/cheats" = {
    source = ./navi;
    recursive = true;
  };
}
