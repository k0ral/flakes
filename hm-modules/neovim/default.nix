{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let
  cfg = config.module.dev.neovim;
in {
  options.module.dev.neovim= {
    enable = mkEnableOption "Neovim module";
  };

    config = mkIf cfg.enable {
    home.packages = with pkgs; [
      neovim
      gcc # Only for tree-sitter
    ];

    xdg.configFile = {
      "nvim/init.vim".source = ./init.vim;
      "nvim/lua/main/init.lua".source = ./lua/main/init.lua;
      "nvim/lua/plugins/init.lua".source = ./lua/plugins/init.lua;
    };
  };
}
