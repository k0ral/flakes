{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let cfg = config.module.wayland;
in {
  imports = [ ./i3status-rust.nix ];

  options.module.wayland = { enable = mkEnableOption "Wayland module"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      clipman
      clipboard-utils
      grim
      imv
      iswaymsg
      lswt
      river
      rofimoji
      slurp
      swappy
      swaybg
      swaylock-effects
      waybar
      wdisplays
      wev
      wl-clipboard
      wlr-randr
      wlrctl
      wlsunset
      xorg.xkbcomp
    ];

    home.sessionVariables = {
      BEMENU_BACKEND = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_TYPE = "wayland";
    };

    module.wayland.fuzzel.enable = true;
    module.wayland.i3status-rust.enable = true;

    services = {
      dunst.enable = true;
      gammastep.enable = true;
      gammastep.dawnTime = "6:00-7:45";
      gammastep.duskTime = "18:35-20:15";
      gammastep.tray = true;
      kanshi = {
        enable = true;
        profiles.docked.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "DP-1";
            status = "enable";
          }
        ];
        profiles.undocked.outputs = [{
          criteria = "eDP-1";
          status = "enable";
        }];
      };
      swayidle.enable = true;
    };

    wayland.windowManager.sway = {
      enable = true;
      config = null;
      extraConfig = builtins.readFile ./sway/config;
      systemd.enable = true;
      wrapperFeatures.gtk = true;
    };

    xdg.configFile = {
      "sway/capture-screen.sh".source = ./sway/capture-screen.sh;
      "sway/commands".source = ./sway/commands;
      "sway/switch-window.sh".source = ./sway/switch-window.sh;
    };
  };
}
