{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let
  cfg = config.module.wayland.hyprland;
  run_cmus = pkgs.writeScript "run_cmus" ''
    #!${pkgs.nushell}/bin/nu

    if (${pkgs.lswt}/bin/lswt -j | from json | get toplevels | where "app-id" == "cmus" | is-empty) {
      ${pkgs.libnotify}/bin/notify-send "Running for the first time..."
      ${pkgs.foot}/bin/foot -a cmus -e /bin/sh -c cmus
    }
  '';
in
{
  options.module.wayland.hyprland = {
    enable = mkEnableOption "Hyprland module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ hyprutils ];

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = false;
      settings = {
        "$mod" = "SUPER";
        cursor = {
          inactive_timeout = 0;
        };
        input = {
          kb_layout = "us_qwerty-fr";
          follow_mouse = 2;
        };
        misc.new_window_takes_over_fullscreen = 1;
        monitor = [
          "eDP-1,preferred,0x0,1"
          ",preferred,auto,1"
        ];
        bindel = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set +5%"
          ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"
          ", XF86KbdBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl -d *::kbd_backlight set +33%"
          ", XF86KbdBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl -d *::kbd_backlight set 33%-"
        ];
        bindl = [
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"
        ];
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
        bind = [
          '', Print, exec, /bin/sh -c 'grim -t ppm -s 1 -g "$(slurp)" - | swappy -f -' ''
          "$mod, Return, exec, foot"
          "$mod, Tab, cyclenext,"
          "$mod SHIFT, Tab, cyclenext, prev"

          "$mod, Prior, workspace, m-1"
          "$mod, Next, workspace, m+1"

          "$mod, F4, killactive"
          "$mod SHIFT, F4, exit"
          "$mod, F11, fullscreen, 2"

          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod SHIFT, left, movewindow, l"
          "$mod SHIFT, right, movewindow, r"
          "$mod SHIFT, up, movewindow, u"
          "$mod SHIFT, down, movewindow, d"

          ''$mod, F, togglefloating, active''
          ''$mod, F, pin, active''
          ''$mod SHIFT, F, exec, ${pkgs.hypraise}/bin/raise --class firefox --launch firefox''
          "$mod, L, exec, swaylock --screenshots --clock --indicator --effect-blur 20x5 --effect-vignette 0.5:0.5 --grace 2 --fade-in 2"
          ''$mod SHIFT, L, exec, ${pkgs.hypraise}/bin/raise --class Logseq --launch logseq''
          "$mod, M, exec, ${run_cmus}"
          "$mod, M, togglespecialworkspace, cmus"
          ''$mod, O, exec, foot -a navi sh -c "sleep 0.01 && navi --tag-rules=bookmark"''
          ''$mod, P, exec, /bin/sh -c '$(sort ~/.config/wayland/commands | ${pkgs.wmenu}/bin/wmenu -f "Victor Mono Nerd Font 16" -l10 -p "command:")' ''
          "$mod, R, exec, fuzzel"
          ''$mod SHIFT, T, exec, ${pkgs.hypraise}/bin/raise --class thunderbird --launch thunderbird''

          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
        ];
        windowrulev2 = [
          "workspace special:cmus, class:^(cmus)$"
          "workspace special:navi, class:^(navi)$"
          "workspace name:logseq, class:^(Logseq)$"
          "workspace name:thunderbird, class:^(thunderbird)$"
        ];
      };
    };
  };
}
