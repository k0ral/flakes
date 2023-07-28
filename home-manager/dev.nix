{ config, pkgs ? import <nixpkgs> { }, ... }:

{
  home.packages = with pkgs; [
    # General purpose
    cookiecutter
    crex
    datasette
    graphviz
    helix
    hugo
    icu
    lazygit
    visidata

    # Provider-specific
    flyctl
    glab
    google-cloud-sdk
    heroku
    oauth2l

    # CSV
    csvs-to-sqlite
    csvkit

    # Dhall
    dhall-json
    haskellPackages.dhall

    # Rust
    cargo
    rust-analyzer
    rustc

    # Shell
    shellcheck
  ];

  module.dev.containers.enable = true;
  module.dev.golang.enable = true;
  module.dev.haskell.enable = true;
  module.dev.neovim.enable = true;
  module.dev.nixlang.enable = true;
  module.dev.python.enable = true;

  module.git = {
    enable = true;
    email = "mail@cmoreau.info";
    username = "koral";
    extraConfig = {
      safe = {
        directory = "/home/nixpkgs";
      };
    };
  };
}
