{ config, lib, pkgs ? import <nixpkgs> { }, user_id, ... }:

{
  home = {
    username = "koral";
    homeDirectory = "/home/${config.home.username}";
    sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];
    sessionVariables = {
      EDITOR = "nvim";
      FZF_DEFAULT_COMMAND = "fd --type f";
      XDG_RUNTIME_DIR = "/run/user/${builtins.toString user_id}";
    };
    shellAliases.e = config.home.sessionVariables.EDITOR;
    stateVersion = "21.05";

    packages = with pkgs; [
      yank

      # Filesystem
      rpi-imager

      # GUI
      giara
      # inkscape
    ];
  };

  imports = [
    ./apps.nix
    ./audio.nix
    ./browser.nix
    ./console.nix
    ./dev.nix
    ./experimental.nix
    ./filesystem.nix
    ./gui.nix
    ./hardware.nix
    ./modules/security.nix
    ./modules/wayland
    ./network.nix
    ./services/backup.nix
    ./services/cleanup.nix
    ./services/wallabag.nix
    ./video.nix
  ];

  module.essential.android.enable = true;
  module.essential.audio.enable = true;
  module.essential.bluetooth.enable = true;
  module.essential.core.enable = true;
  module.essential.dev.enable = true;
  module.essential.multimedia.enable = true;
  module.essential.nix.enable = true;
  module.programs.detox.enable = true;
  module.security.enable = true;
  module.utilities.compression.enable = true;
  module.utilities.trash.enable = true;
  module.wayland.enable = true;

  services.udiskie = {
    enable = true;
    settings = {
      device_config = [{
        id_uuid = "f4082ec9-83d7-4813-848e-033d50891ff2";
        keyfile = "${config.xdg.configHome}/secrets/bodhi.keyfile";
      }
      {
        id_uuid = "3ead5fae-15e6-4282-8b5c-60feda55f1df";
        keyfile = "${config.xdg.configHome}/secrets/gorion.keyfile";
      }];
    };
  };

  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ../secrets/personal.yaml;
  };
}
