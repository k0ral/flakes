{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let
  cfg = config.module.programs.detox;
in {
  options.module.programs.detox = {
    enable = mkEnableOption "detox module";
  };

  config = mkIf cfg.enable {
    home.file.".detoxrc".text = ''
      sequence default {
        utf_8;
        safe;
        wipeup {
          remove_trailing;
        };
        lower;
      };
    '';

    home.packages = with pkgs; [ detox ];
  };
}
