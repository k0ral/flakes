{ config, pkgs ? import <nixpkgs> { }, ... }:

{
  home.packages = with pkgs; [
    atop
    cpulimit
    hdparm
    light
    lm_sensors
    powertop
    procs
    ps_mem
    psmisc
    upower
  ];

  module.btop.enable = true;

  xdg.configFile."xkb/symbols/us_qwerty-fr".source = "${pkgs.qwerty-fr}/usr/share/X11/xkb/symbols/us_qwerty-fr";
}
