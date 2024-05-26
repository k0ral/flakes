{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let
  cfg = config.module.wayland.waybar;
in
{
  options.module.wayland.waybar = {
    enable = mkEnableOption "waybar module";
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 22;
          spacing = 4;
          modules-left = [ "hyprland/workspaces" "privacy" "custom/cmus" ];
          # modules-center = [ "sway/window" "custom/hello-from-waybar" ];
          modules-right = [ "network#wireless" "network#wired" "disk" "memory" "cpu" "temperature" "temperature#cpu" "backlight" "wireplumber" "battery" "clock" "tray" ];
          backlight = {
            format = "💡 {percent}%";
          };
          battery = {
            format = "🔌 {capacity}% {power}W {time}";
            states.good = 95;
            states.warning = 40;
            states.critical = 15;
          };
          clock = {
            format = "🕓 {:%Y-%m-%d %H:%M}";
          };
          cpu = {
            format = "  {usage}%";
          };
          "custom/cmus" = {
            format = "♪ {}";
            #max-length = 15;
            interval = 10;
            exec = "cmus-remote -C \"format_print '%a - %t'\"";
            exec-if = "pgrep cmus";
            on-click = "cmus-remote -u";
            escape = true;
          };
          disk = {
            format = "{path} {free}";
            path = "/";
          };
          "hyprland/workspaces" = {
            "show-special" = true;
          };
          memory = {
            format = " {used}GiB ({percentage}%)";
          };
          "network#wireless" = {
            interface = "wlo1";
            interval = 7;
            format = "🛜 {essid} {signalStrength}% {ipaddr} 🔻{bandwidthDownBytes} 🔺{bandwidthUpBytes}";
            format-disconnected = "";
          };
          "network#wired" = {
            interface = "enp2s0";
            interval = 7;
            format = "🌐 {ipaddr} 🔻{bandwidthDownBytes} 🔺{bandwidthUpBytes}";
            format-disconnected = "";
          };
          privacy = {
            icon-spacing = 4;
            icon-size = 18;
            transition-duration = 250;
            modules = [
              {
                type = "screenshare";
                tooltip = true;
                tooltip-icon-size = 24;
              }
              {
                type = "audio-out";
                tooltip = true;
                tooltip-icon-size = 24;
              }
              {
                type = "audio-in";
                tooltip = true;
                tooltip-icon-size = 24;
              }
            ];
          };
          temperature = {
            format = "🌡️ {temperatureC}°C";
          };
          "temperature#cpu" = {
            hwmon-path = "/sys/class/hwmon/hwmon1/temp1_input";
            format = "🌡️ CPU {temperatureC}°C";
          };
          wireplumber = {
            format = "🔊 {volume}%";
            format-muted = "🔇";
            on-click = "helvum";
            scroll-step = 5;
          };
        };
      };
      style = ''
        * {
          font-family: "VictorMono Nerd Font";
          font-size: 18px;
          min-height: 0;
        }

        window#waybar {
          background: transparent;
          color: #ffffff;
          transition-property: background-color;
          transition-duration: .5s;
        }

        window#waybar.hidden {
          opacity: 0.2;
        }

        #waybar.empty #window {
          background-color: transparent;
        }

        #workspaces {
        }

        #window {
          margin: 2;
          padding-left: 8;
          padding-right: 8;
          background-color: rgba(0,0,0,0.3);
          font-size:14px;
          font-weight: bold;
        }

        button {
          /* Use box-shadow instead of border so the text isn't offset */
          box-shadow: inset 0 -3px transparent;
          /* Avoid rounded borders under each button name */
          border: none;
          border-radius: 0;
        }

        /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
        button:hover {
          background: inherit;
          border-top: 2px solid #c9545d;
        }

        #workspaces button {
          padding: 0 4px;
          background-color: rgba(0,0,0,0.3);
        }

        #workspaces button:hover {
        }

        #workspaces button.focused {
          /*    box-shadow: inset 0 -2px #c9545d; */
          background-color: rgba(0,0,0,0.3);
          color:#c9545d;
          border-top: 2px solid #c9545d;
        }

        #workspaces button.urgent {
          background-color: #eb4d4b;
        }

        #clock, #battery, #cpu, #memory, #disk, #temperature, #backlight, #network, #wireplumber, #tray, #mode, #idle_inhibitor {
          margin: 2px;
          padding-left: 4px;
          padding-right: 4px;
          background-color: rgba(0,0,0,0.5);
          color: #ffffff;
        }

        /* If workspaces is the leftmost module, omit left margin */
        .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
        }

        /* If workspaces is the rightmost module, omit right margin */
        .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
        }

        #clock {
          font-weight: bold;
        }

        #battery icon {
          color: red;
        }

        #battery.charging, #battery.plugged {
          color: #ffffff;
          background-color: #26A65B;
        }

        @keyframes blink {
          to {
            background-color: #ffffff;
            color: #000000;
          }
        }

        #battery.warning:not(.charging) {
          background-color: #f53c3c;
          color: #ffffff;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        #battery.critical:not(.charging) {
          background-color: #f53c3c;
          color: #ffffff;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        label:focus {
          background-color: #000000;
        }

        #network.disconnected {
          background-color: #f53c3c;
        }

        #temperature.critical {
          background-color: #eb4d4b;
        }

        #idle_inhibitor.activated {
          background-color: #ecf0f1;
          color: #2d3436;
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #eb4d4b;
        }
      '';
      systemd.enable = true;
    };
  };
}
