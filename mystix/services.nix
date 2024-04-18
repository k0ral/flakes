{ config, pkgs, ... }: {

  services.acpid.enable = true;
  services.acpid.handlers = {
    volumeDown = {
      event = "button/volumedown";
      action = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-";
    };
    volumeUp = {
      event = "button/volumeup";
      action = "${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 3%+";
    };
    mute = {
      event = "button/mute";
      action = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
    };
    cdPlay = {
      event = "cd/play.*";
      action = "${pkgs.mpc_cli}/bin/mpc toggle";
    };
    cdNext = {
      event = "cd/next.*";
      action = "${pkgs.mpc_cli}/bin/mpc next";
    };
    cdPrev = {
      event = "cd/prev.*";
      action = "${pkgs.mpc_cli}/bin/mpc prev";
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.dnsmasq = {
    enable = true;
    # settings.servers = config.networking.nameservers;
  };

  services.gvfs.enable = true;
  services.journald.extraConfig = "SystemMaxUse=100M";
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleSuspendKey=ignore
    HandleHibernateKey=ignore
    HandleLidSwitch=ignore
  '';

  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    extraConfig = ''
      X11Forwarding no
    '';
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;
  services.privoxy.enable = true;
  services.pcscd.enable = true;
  services.radicale = {
    enable = true;
    settings = { server = { hosts = [ "0.0.0.0:5232" "[::]:5232" ]; }; };
  };
  services.smartd.enable = true;
  services.thermald.enable = true;
  services.tlp.enable = true;
  services.udisks2.enable = true;
  services.upower.enable = true;
}
