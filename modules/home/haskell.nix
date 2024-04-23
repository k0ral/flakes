{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let
  cfg = config.module.dev.haskell;
in {
  options.module.dev.haskell = {
    enable = mkEnableOption "Haskell module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      haskell-language-server
      haskellPackages.apply-refact
      # haskellPackages.ghcide
      haskellPackages.hlint
      haskellPackages.fourmolu
      haskellPackages.stylish-haskell
    ];

    xdg.configFile = {
      "stylish-haskell/config.yaml".text = ''
        steps:
          - simple_align:
              cases: true
              top_level_patterns: true
              records: true
          - imports:
              align: global
              list_align: after_alias
              pad_module_names: true
              long_list_align: inline
              empty_list_align: inherit
              list_padding: 4
              separate_lists: true
              space_surround: false
          - language_pragmas:
              style: vertical
              align: true
              remove_redundant: true
          - trailing_whitespace: {}
        columns: 120
        newline: native
        cabal: true
      '';
    };
  };
}
