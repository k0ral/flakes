{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./programs.nix
    ./services.nix
    ./wayland.nix
  ];

  boot = {
    kernelModules = [ "coretemp" "k10temp" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = false;
    supportedFilesystems = [ "zfs" ];
    tmp.cleanOnBoot = true;
  };

  console.keyMap = "us";

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

    pulseaudio.enable = false;
    sane.enable = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    firewall.allowedTCPPorts = [ 873 5232 6600 9090 15000 ];
    firewall.enable = true;
    enableIPv6 = true;
    hostId = "01ed4135";
    hostName = "mystix";
    networkmanager.enable = true;
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 10d";
    };
    package = pkgs.nixFlakes;
    settings = {
      auto-optimise-store = true;
      sandbox = true;
      substituters = [ "https://cache.nixos.org/" ];
      trusted-users = [ "@wheel" ];
    };
  };

  powerManagement = { cpuFreqGovernor = "ondemand"; };

  programs.fuse.userAllowOther = true;

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
  security.sudo.execWheelOnly = true;

  system.autoUpgrade.enable = false;

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
    shell = pkgs.fish;
    uid = 1000;
  };

  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
    dockerCompat = true;
  };

  xdg = { icons.enable = true; };
}
