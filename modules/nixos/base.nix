{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let cfg = config.module.nixos.base;
in {
  options.module.nixos.base = {
    enable = mkEnableOption "Reasonable defaults settings for NixOS";
  };

  config = mkIf cfg.enable {
    boot = {
      tmp.cleanOnBoot = lib.mkDefault true;
    };

    console.keyMap = lib.mkDefault "us";

    hardware = {
      pulseaudio.enable = lib.mkDefault false;
    };

    i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

    networking = {
      enableIPv6 = lib.mkDefault true;
      firewall.enable = lib.mkDefault true;
    };

    nix = {
      extraOptions = lib.mkDefault ''
        experimental-features = nix-command flakes
      '';
      gc = {
        automatic = lib.mkDefault true;
        dates = lib.mkDefault "daily";
        options = lib.mkDefault "--delete-older-than 10d";
      };
      package = lib.mkDefault pkgs.nixFlakes;
      settings = {
        auto-optimise-store = lib.mkDefault true;
        sandbox = lib.mkDefault true;
        substituters = lib.mkDefault [ "https://cache.nixos.org/" ];
        trusted-users = lib.mkDefault [ "@wheel" ];
      };
    };

    programs = {
      fuse.userAllowOther = lib.mkDefault true;
      nano.enable = lib.mkDefault true;
      nano.nanorc = lib.mkDefault ''
        set nowrap
        set tabstospaces
        set tabsize 2
      '';
    };

    security.sudo = {
      enable = lib.mkDefault true;
      execWheelOnly = lib.mkDefault true;
    };

    services.journald.extraConfig = lib.mkDefault "SystemMaxUse=100M";
    services.openssh = {
      enable = lib.mkDefault true;
      settings.PermitRootLogin = lib.mkDefault "no";
    };

    system.autoUpgrade.enable = lib.mkDefault false;
  };
}
