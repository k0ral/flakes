{ config, inputs, outputs, network, pkgs, user_id, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./programs.nix
    ./services.nix
    ./wayland.nix
    ./wireguard.nix

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.extraSpecialArgs = { inherit pkgs user_id; };
      home-manager.sharedModules = pkgs.lib.attrValues outputs.modules.home ++ [
        inputs.sops-nix.homeManagerModules.sops
      ];
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.koral = import ../home-manager/home.nix;
    }
    inputs.sops-nix.nixosModules.sops
  ];

  module.nixos.base.enable = true;
  module.nixos.ntfs.enable = true;

  boot = {
    kernelModules = [ "coretemp" "k10temp" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = false;
  };

  environment.variables = { };

  environment.etc."sysconfig/lm_sensors".text = ''
    HWMON_MODULES="coretemp"
  '';

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
    fontDir.enable = true;
    packages = with pkgs; [
      corefonts # Microsoft free fonts
      # encode-sans
      font-awesome
      libre-baskerville
      nerdfonts
      # noto-fonts
      # google-fonts
      # source-han-sans
      # source-han-mono
      # source-han-serif
      ubuntu_font_family
      unifont # some international languages
    ];
    fontconfig.defaultFonts.monospace = [ "Hack" ];
  };

  hardware = {
    bluetooth.enable = false;
    bluetooth.settings.General = {
      Enable = "Control,Gateway,Headset,Media,Sink,Socket,Source";
      UserspaceHID = true;
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    sane.enable = true;
  };

  networking = {
    firewall.allowedTCPPorts = [ 873 5232 6600 9090 15000 ];
    hostId = "01ed4135";
    hostName = "mystix";
    networkmanager.enable = true;
  };

  nix = {
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = ["nixpkgs=flake:nixpkgs"];
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.swaylock = { };
  security.polkit = {
    enable = true;
    extraConfig = ''
      // Allow udisks2 to mount devices without authentication
      // for users in the "wheel" group.
      polkit.addRule(function(action, subject) {
          if ((action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
               action.id == "org.freedesktop.udisks2.filesystem-mount") &&
              subject.isInGroup("wheel")) {
              return polkit.Result.YES;
          }
      });
    '';
  };

  sops = {
    defaultSopsFile = ../secrets/personal.yaml;
    age.keyFile = "/var/lib/sops-nix/keys.txt";
  };

  time.timeZone = "Europe/Paris";

  users.extraUsers.koral = {
    createHome = true;
    extraGroups = [
      "adbusers"
      "aria2"
      "lp"
      "podman"
      "scanner"
      "sway"
      "video"
      "wheel"
    ];
    isNormalUser = true;
    shell = pkgs.nushell;
    uid = user_id;
  };

  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
    dockerCompat = true;
  };

  xdg = { icons.enable = true; };
}
