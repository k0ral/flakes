{ config, pkgs ? import <nixpkgs> { }, ... }:

{
  home.packages = with pkgs; [
    arp-scan
    nethogs
    nload
    speedtest-cli
    tcpdump
    tcpflow
  ];
}
