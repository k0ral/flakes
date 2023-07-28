{ config, pkgs ? import <nixpkgs> { }, ... }:

{
  home.packages = with pkgs; [
    neovim
    gcc # Only for tree-sitter
  ];

  xdg.configFile = {
    "nvim/init.vim".source = ./init.vim;
    "nvim/lua/main/init.lua".source = ./lua/main/init.lua;
    "nvim/lua/plugins/init.lua".source = ./lua/plugins/init.lua;
  };
}
