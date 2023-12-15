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
  module.hardware.us-qwerty-fr.enable = true;
}
