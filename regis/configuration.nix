{ config, pkgs, lib, inputs, ... }:

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
    gateway_ip = "192.168.1.254";
    subnet_mask = "255.255.255.0";
    range_start = "192.168.1.200";
    range_end = "192.168.1.251";
  };
  module.nixos.home-assistant = {
    enable = true;
  };

  networking = {
    defaultGateway = "192.168.1.254";
    hostName = "regis";
    interfaces.end0.ipv4.addresses = [{
      address = "192.168.1.11";
      prefixLength = 24;
    }];
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
