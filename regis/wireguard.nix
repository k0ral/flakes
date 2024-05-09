{ config, lib, pkgs ? import <nixpkgs> { }, network, ... }:

let externalInterface = "end0";
in {
  networking = {
    nat = {
      enable = true;
      externalInterface = externalInterface;
      internalInterfaces = [ "wg0" ];
    };
    firewall.allowedUDPPorts = [ network.wireguard.port ];
    wireguard.interfaces.wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [ "${network.wireguard.peers.regis.ipv4}/24" ];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = network.wireguard.port;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${externalInterface} -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${externalInterface} -j MASQUERADE
      '';

      privateKeyFile = config.sops.secrets."wireguard/regis/private-key".path;

      # List of allowed peers.
      peers = [
        {
          name = "phone";
          publicKey = network.wireguard.peers.phone.publicKey;
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          allowedIPs = [ "${network.wireguard.peers.phone.ipv4}/32" ];
        }
        {
          name = "mystix";
          publicKey = network.wireguard.peers.mystix.publicKey;
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          allowedIPs = [ "${network.wireguard.peers.mystix.ipv4}/32" ];
        }
      ];
    };
  };

  sops.secrets."wireguard/regis/private-key" = { };
}
