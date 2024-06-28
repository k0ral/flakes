{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let
  cfg = config.module.wayland;
in {
  options.module.wayland = { enable = mkEnableOption "Wayland module"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      grim
      imv
      lswt
      river
      rofimoji
      slurp
      swappy
      swaybg
      swaylock-effects
      wdisplays
      wev
      wl-clipboard
      wlr-randr
      wlrctl
      wlsunset
      wmenu
      xorg.xkbcomp
    ];

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      XDG_SESSION_TYPE = "wayland";
    };

    module.wayland.clipboard-utils.enable = true;
    module.wayland.fuzzel.enable = true;
    module.wayland.hyprland.enable = true;
    module.wayland.wallit.enable = true;
    module.wayland.waybar.enable = true;

    services = {
      dunst.enable = true;
      dunst.settings = {
        global.font = "VictorMono Nerd Font 14";
        global.width = "(0, 1000)";
      };
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

    xdg.configFile = {
      "wayland/commands".text = ''
        clipboard-notify
        clipboard-qrencode
        rofimoji --action type copy --selector wmenu --selector-args="" --clipboarder wl-copy --typer wtype
        foot ihyprctl-output-disable
        foot ihyprctl-output-enable
        foot iudiskie-umount
        foot select-sink
        systemctl hibernate
        systemctl poweroff
        systemctl reboot
        systemctl suspend
        udiskie-mount -a
      '';
    };
  };
}
