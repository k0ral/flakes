{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let cfg = config.module.nixos.adguardhome;
in {
  options.module.nixos.adguardhome = {
    enable = mkEnableOption "AdGuard Home module";
    interface = mkOption { type = types.str; };
    gateway_ip = mkOption { type = types.str; };
    subnet_mask = mkOption { type = types.str; };
    range_start = mkOption { type = types.str; };
    range_end = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [ 53 67 ];
      allowedUDPPorts = [ 53 67 ];
    };

    services.adguardhome = {
      enable = true;
      openFirewall = true;
      settings = {
        dhcp = {
          enabled = true;
          interface_name = cfg.interface;
          dhcpv4 = {
            gateway_ip = cfg.gateway_ip;
            subnet_mask = cfg.subnet_mask;
            range_start = cfg.range_start;
            range_end = cfg.range_end;
          };
        };
        dns = {
          upstream_dns = [
            "https://dns.quad9.net/dns-query"
            "https://dns.cloudflare.com/dns-query"
            #"https://dns10.quad9.net/dns-query"
          ];
        };
        filters = [{
          enabled = false;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
          name = "AdGuard DNS filter";
          id = 1;
        }
          {
            enabled = false;
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt";
            name = "AdAway Default Blocklist";
            id = 2;
          }
          {
            enabled = false;
            url = "https://raw.githubusercontent.com/ph00lt0/blocklists/master/blocklist.txt";
            name = "ph00lt0/blocklist";
            id = 3;
          }
          {
            enabled = true;
            url = "https://github.com/ppfeufer/adguard-filter-list/blob/master/blocklist?raw=true";
            name = "ppfeufer/adguard-filter-list";
            id = 4;
          }];
        theme = "dark";
        user_rules = [
          "@@||api.datadoghq.eu^"
          "@@||app.datadoghq.eu^"
          "@@||static.datadoghq.com^"
          "@@||docs.datadoghq.com^"
          "@@||facebook.com^"
          "@@||xx.fbcdn.net^"
        ];
      };
    };
  };
}
