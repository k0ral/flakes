{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let cfg = config.module.wayland.sway;
    mod = config.wayland.windowManager.sway.config.modifier;
in {
  options.module.wayland.sway = { enable = mkEnableOption "sway module"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ iswaymsg ];
    home.sessionVariables = { XDG_CURRENT_DESKTOP = "sway"; };

    module.wayland.i3status-rust.enable = true;

    wayland.windowManager.sway = {
      enable = true;
      config = {
        bars = [{
          colors.background = "#000032";
          colors.statusline = "#ffffff";
          fonts = {
            names =
              [ "VictorMono Nerd Font" "Victor Mono" "FontAwesome" "Hack" ];
            size = 13.0;
          };
          position = "top";
          statusCommand =
            "i3status-rs ~/.config/i3status-rust/config-default.toml";
        }];
        focus = {
          followMouse = "no";
          wrapping = "yes";
        };
        fonts = {
          names = [ "VictorMono Nerd Font" ];
          size = 13.0;
        };
        gaps = {
          inner = 5;
          smartGaps = true;
        };
        input = {
          "type:keyboard" = {
            xkb_layout = "us_qwerty-fr";
            # xkb_numlock enabled
          };
          "type:mouse" = { dwt = "true"; };
        };
        keybindings = lib.mkOptionDefault {
          "${mod}+0" = "workspace number 10";
          "${mod}+Shift+0" = "move container to workspace number 10";

          "${mod}+F4" = "kill";
          "${mod}+F5" = "reload";
          "${mod}+F11" = "fullscreen";
          Print = ''exec /bin/sh -c 'grim -t ppm -s 1 -g "$(slurp)" - | swappy -f -' '';
          "${mod}+backspace" = "layout toggle all";

          "${mod}+Ctrl+Left" = "resize shrink width";
          "${mod}+Ctrl+Right" = "resize grow width";
          "${mod}+Ctrl+Down" = "resize shrink height";
          "${mod}+Ctrl+Up" = "resize grow height";

          XF86AudioPlay = "exec --no-startup-id playerctl play-pause";
          XF86AudioNext = "exec --no-startup-id playerctl next";
          XF86AudioPrev = "exec --no-startup-id playerctl previous";
          XF86AudioRaiseVolume = "exec pamixer -i 4";
          XF86AudioLowerVolume = "exec pamixer -d 4";
          XF86AudioMute = "exec pamixer -t";

          "${mod}+g" = "exec foot iswaymsg-goto";
          "${mod}+l" =
            "exec swaylock --screenshots --clock --indicator --effect-blur 20x5 --effect-vignette 0.5:0.5 --grace 2 --fade-in 2";
          "${mod}+m" = ''
            [app_id="cmus_music"] scratchpad show, resize set width 90 ppt height 90 ppt, move position center'';
          "${mod}+o" =
            ''exec foot sh -c "sleep 0.01 && navi --tag-rules=bookmark"'';
          "${mod}+p" = ''
            exec /bin/sh -c '$(sort ~/.config/sway/commands | ${pkgs.wmenu}/bin/wmenu -f "Victor Mono Nerd Font 16" -l10 -p "command:")' '';
          "${mod}+r" = "exec fuzzel";

          "${mod}+Shift+f" =
            "exec ~/.config/sway/run-or-raise.py firefox firefox";
          "${mod}+Shift+o" =
            "exec ~/.config/sway/run-or-raise.py obsidian obsidian";
          "${mod}+Shift+t" =
            "exec ~/.config/sway/run-or-raise.py thunderbird thunderbird";

          "${mod}+Tab" = "focus next";
          "${mod}+Shift+Tab" = "focus prev";

          "${mod}+Prior" = "workspace prev_on_output";
          "${mod}+Next" = "workspace next_on_output";
        };
        modes = {
          move = {
            Left = "move workspace to output left";
            Right = "move workspace to output right";
            Up = "move workspace to output up";
            Down = "move workspace to output down";

            "${mod}+Left" = "workspace prev";
            "${mod}+Right" = "workspace next";
            "${mod}+Prior" = "workspace prev";
            "${mod}+Next" = "workspace next";

            "${mod}+Shift+m" = ''"mode "default"'';
            Escape = ''mode "default"'';
          };
          passthrough = { "${mod}+F12" = ''mode "default"''; };
          resize = {
            Left = "resize shrink width 50 px";
            Down = "resize grow height 50 px";
            Up = "resize shrink height 50 px";
            Right = "resize grow width 50 px";

            Return = ''mode "default"'';
            Escape = ''mode "default"'';
            "${mod}+d" = ''mode "default"'';
          };
        };
        modifier = "Mod4";
        startup = [
          { command = "${pkgs.foot}/bin/foot"; }
          { command = "wl-paste --watch wl-copy -p"; }
          {
            command =
              "${pkgs.foot}/bin/foot --app-id=cmus_music -e /bin/sh -c cmus";
          }
          # { command = "wl-sunset -l 48.51 -L 2.20"; }
        ];
        terminal = "${pkgs.foot}/bin/foot";
        window = {
          commands = [{
            command =
              "floating enable, sticky enable, resize set width 90 ppt height 90 ppt, move position center, move scratchpad";
            criteria.app_id = "music";
          }];
          hideEdgeBorders = "smart";
        };
        workspaceLayout = "tabbed";
      };
      systemd.enable = true;
      wrapperFeatures.gtk = true;
      xwayland = false;
    };

    xdg.configFile = {
      "sway/commands".text = ''
        clipboard-notify
        clipboard-qrencode
        swaymsg floating enable
        swaymsg floating disable
        swaymsg floating auto
        swaymsg reload
        swaymsg layout stacking
        swaymsg layout tabbed
        swaymsg layout splith
        swaymsg layout splitv
        swaymsg layout toggle all
        swaymsg layout toggle split
        swaymsg mode passthrough
        swaymsg mode move
        swaymsg sticky disable
        swaymsg sticky enable
        swaymsg sticky toggle
        rofimoji --action type copy --selector wmenu --selector-args="" --clipboarder wl-copy --typer wtype
        foot iswaymsg-output-disable
        foot iswaymsg-output-enable
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
