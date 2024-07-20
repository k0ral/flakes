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
      "nvim/init.lua".source = ./init.lua;
      "nvim/lua/config/lazy.lua".source = ./lua/config/lazy.lua;
      "nvim/lua/plugins/init.lua".source = ./lua/plugins/init.lua;
      "nvim/lua/plugins/go.lua".source = ./lua/plugins/go.lua;
      "nvim/lua/plugins/lualine.lua".source = ./lua/plugins/lualine.lua;
      "nvim/lua/plugins/nvim-treesitter.lua".source = ./lua/plugins/nvim-treesitter.lua;
    };
  };
}
