{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let cfg = config.module.nixos.wireguard;
in {
  options.module.nixos.wireguard = {
    enable = mkEnableOption "WireGuard module";
    externalInterface = mkOption { type = types.str; };
    privateKeyFile = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable {
    networking = {
      nat = {
        enable = true;
        externalInterface = cfg.externalInterface;
        internalInterfaces = [ "wg0" ];
      };
      firewall.allowedUDPPorts = [ 5182 ];
      wireguard.interfaces = {
        wg0 = {
          # Determines the IP address and subnet of the server's end of the tunnel interface.
          ips = [ "10.100.0.1/24" ];

          # The port that WireGuard listens to. Must be accessible by the client.
          listenPort = 5182;

          # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
          # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
          postSetup = ''
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${cfg.externalInterface} -j MASQUERADE
          '';

          # This undoes the above command
          postShutdown = ''
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${cfg.externalInterface} -j MASQUERADE
          '';

          privateKeyFile = cfg.privateKeyFile;

          # List of allowed peers.
          peers = [
            {
              name = "phone";
              publicKey = "Lexu2E53e/y+yueG8JqYwP8hn/xIGyGPIg25x24jZ28=";
              # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
              allowedIPs = [ "10.100.0.2/32" ];
            }
          ];
        };
      };
    };
  };
}
