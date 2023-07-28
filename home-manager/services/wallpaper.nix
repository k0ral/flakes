{ config, pkgs ? import <nixpkgs> { }, ... }:

{
  systemd.user.services.wallpaper = {
    Unit.Description = "Wallpaper generator";
    Install.WantedBy = [ "default.target" ];

    Service = {
      ExecStart = [ "-${pkgs.wallit}/bin/wallit" ];

      Type = "oneshot";
    };
  };

  systemd.user.timers.wallpaper = {
    Install.WantedBy = [ "timers.target" ];

    Timer = {
      Unit = "wallpaper.service";
      OnCalendar = "*-*-* *:00,10,20,30,40,50:00";
    };
  };
}
