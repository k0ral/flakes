{ config, lib, pkgs ? import <nixpkgs> { }, outputs, ... }:
with lib;

let
  cfg = config.module.apps.s;
in {
  options.module.apps.s = {
    enable = mkEnableOption "s module";
  };

  config = mkIf cfg.enable {
    xdg.configFile."s/config".text = ''
      provider: duckduckgo
      whitelist: [amazon, archwiki, crates, dockerhub, facebook, github, go, godoc, google, googlemaps, kagi, pypi, python, reddit, stackoverflow, steam, wikipedia, youtube]
      customProviders [
        {
          name: crates
          url: "https://crates.io/search?q=%s"
          tags: [rust]
        }
      ]

    '';

    home.packages = [
      (outputs.packages.${pkgs.system}.s)
    ];
  };
}
