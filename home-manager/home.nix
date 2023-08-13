{ config, lib, pkgs ? import <nixpkgs> { }, ... }:

{
  home = {
    username = "koral";
    homeDirectory = "/home/koral";
    sessionVariables = {
      EDITOR = "nvim";
      FZF_DEFAULT_COMMAND = "fd --type f";
      XDG_RUNTIME_DIR = "/run/user/$UID";
    };
    shellAliases.e = config.home.sessionVariables.EDITOR;
    stateVersion = "21.05";

    packages = with pkgs; [
      # Console
      loop
      # ncurses.dev
      yank

      # Filesystem
      detox
      rpi-imager

      # GUI
      giara
      # inkscape

      # Utils
      gtg
      hledger
      hledger-ui
      # unipicker

      # Communication
      thunderbird
    ];
  };

  imports = [
    ./audio.nix
    ./console.nix
    ./dev.nix
    ./experimental.nix
    ./filesystem.nix
    ./gui.nix
    ./hardware.nix
    ./modules/obsidian.nix
    ./modules/security.nix
    ./modules/wayland
    ./modules/web.nix
    ./network.nix
    ./services/backup.nix
    ./services/cleanup.nix
    ./services/wallabag.nix
    ./services/wallpaper.nix
    ./video.nix
  ];

  module.essential.android.enable = true;
  module.essential.audio.enable = true;
  module.essential.bluetooth.enable = true;
  module.essential.core.enable = true;
  module.essential.dev.enable = true;
  module.essential.multimedia.enable = true;
  module.essential.nix.enable = true;
  module.ferdium.enable = true;
  module.obsidian.enable = true;
  module.security.enable = true;
  module.utilities.compression.enable = true;
  module.utilities.trash.enable = true;
  module.wayland.enable = true;
  module.web.enable = true;

  services.pueue = {
    enable = true;
    settings = {
      shared = {};
    };
  };
  services.udiskie = {
    enable = true;
  };
}
