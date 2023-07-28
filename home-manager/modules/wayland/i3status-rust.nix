{ config, lib, pkgs ? import <nixpkgs> {}, ... }:
with lib;

let
  cfg = config.module.wayland.i3status-rust;
in {
  options.module.wayland.i3status-rust = {
    enable = mkEnableOption "i3status-rust module";
    username = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      i3status-rust
    ];

    programs.i3status-rust.enable = true;
    programs.i3status-rust.bars.default = {
      blocks = [
      {
        block = "service_status";
        service = "privoxy";
        active_format = "🔵";
        inactive_format = " 🔴 privoxy ";
      }{
        block = "service_status";
        service = "dnsmasq";
        active_format = "🔵";
        inactive_format = " 🔴 dnsmasq ";
      }{
        block = "service_status";
        service = "cups";
        active_format = "🔵";
        inactive_format = " 🔴 cups ";
      }{
        block = "service_status";
        service = "radicale";
        active_format = "🔵";
        inactive_format = " 🔴 radicale ";
      }{
        block = "net";
        device = "enp2s0";
        format = " $icon $ip ↓$speed_down ↑$speed_up ";
        interval = 3;
      }{
        block = "net";
        device = "wlo1";
        format = " $icon $ssid $signal_strength $ip ↓$speed_down ↑$speed_up ";
        interval = 3;
      }{
        block = "disk_space";
        format = " $icon $path $available";
      }{
        block = "memory";
        format = " $icon $mem_used ($mem_used_percents) ";
      }{
        block = "cpu";
        interval = 11;
        format = " $icon $utilization $frequency ";
      }{
        block = "temperature";
        interval = 11;
        format = " $icon $average ";
      }{
        block = "custom";
        command = "${pkgs.statusbar-utils}/bin/fastmail-unread";
        interval = 127;
      }{
        block = "custom";
        command = "${pkgs.statusbar-utils}/bin/gmail-unread";
        interval = 127;
      }{
        block = "backlight";
      }{
        block = "sound";
        driver = "pulseaudio";
      }{
        block = "battery";
        interval = 31;
        format = " $icon $percentage $time ";
      }{
        block = "time";
        interval = 60;
        format = " $icon $timestamp.datetime(f:'%F %R') ";
      }];
      settings.theme = {
        theme = "solarized-dark";
        overrides.idle_bg = "#000011";
      };
      icons = "awesome5";
    };
  };
}
