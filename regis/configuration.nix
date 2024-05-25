{ config, pkgs, lib, inputs, outputs, network, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    inputs.sops-nix.nixosModules.sops
    ./wireguard.nix
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  module.nixos.base.enable = true;
  module.nixos.adguardhome = {
    enable = true;
    interface = "end0";
    gateway_ip = network.homeLAN.gateway.ipv4;
    subnet_mask = network.homeLAN.subnetMask;
    range_start = "192.168.1.200";
    range_end = "192.168.1.251";
  };
  module.nixos.home-assistant = {
    enable = true;
  };
  module.nixos.ntfy = {
    enable = true;
    host = network.homeLAN.regis.ipv4;
    port = 9876;
  };

  networking = {
    defaultGateway = network.homeLAN.gateway.ipv4;
    hostName = "regis";
    interfaces.end0 = {
      ipv4.addresses = [{
        address = network.homeLAN.regis.ipv4;
        prefixLength = 24;
      }];
    };
    wireless = {
      enable = false;
      environmentFile = config.sops.secrets."wireless.env".path;
      networks."@SSID@".psk = "@PASSWORD@";
      interfaces = [ "wlan0" ];
    };
  };

  environment.systemPackages = with pkgs; [ libraspberrypi ];

  sops = {
    defaultSopsFile = ../secrets/personal.yaml;
    age.keyFile = "/var/lib/sops-nix/keys.txt";
    secrets = {
      "users/koral/hashed-password".neededForUsers = true;
      "wireless.env" = {};
    };
  };

  users = {
    mutableUsers = false;
    users.koral = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets."users/koral/hashed-password".path;
      extraGroups = [ "wheel" ];
    };
  };

  system.stateVersion = "23.11";
}
