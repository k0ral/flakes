{ config, lib, pkgs ? import <nixpkgs> { }, network, ... }:

{
  networking = {
    # Clients and peers can use the same port, see listenport
    firewall.allowedUDPPorts = [ network.wireguard.port ];

    wireguard.interfaces.wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "${network.wireguard.peers.mystix.ipv4}/24" ];
      listenPort = network.wireguard.port; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

      privateKeyFile = config.sops.secrets."wireguard/mystix/private-key".path;

      # For a client configuration, one peer entry for the server will suffice.
      peers = [{
        publicKey = network.wireguard.peers.regis.publicKey;

        # Forward all the traffic via VPN.
        # allowedIPs = [ "0.0.0.0/0" ];
        # Or forward only particular subnets
        allowedIPs = [ network.wireguard.peers.regis.ipv4 network.homeLAN.regis.ipv4 ];

        # ToDo: route to endpoint not automatically configured
        # https://wiki.archlinux.org/index.php/WireGuard#Loop_routing
        # https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
        endpoint = "${network.publicIPv4}:${builtins.toString network.wireguard.port}";

        # Send keepalives every 25 seconds. Important to keep NAT tables alive.
        persistentKeepalive = 25;
      }];
    };
  };

  sops.secrets."wireguard/mystix/private-key" = { };
}
