{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let cfg = config.module.wayland.wallit;
in {
  options.module.wayland.wallit = {
    enable = mkEnableOption "Wallpaper module";
    period = mkOption {
      type = types.str;
      default = "10min";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.wallpaper = {
      Unit = {
        Description = "Wallpaper generator";
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      Install.WantedBy = [ "graphical-session.target" ];

      Service = {
        ExecStart = [ "${pkgs.wallit}/bin/wallit" ];
        Type = "simple";
        Restart = "always";
      };
    };

    systemd.user.services.wallpaper-shuffle = {
      Unit.Description = "Wallpaper shuffle";

      Service = {
        ExecStart = [ "${pkgs.systemd}/bin/systemctl --user restart wallpaper" ];
        Type = "oneshot";
      };
    };

    systemd.user.timers.wallpaper-shuffle = {
      Unit = {
        Description = "Wallpaper timer";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session-pre.target" ];
      };
      Install.WantedBy = [ "graphical-session.target" ];

      Timer = {
        Unit = "wallpaper-shuffle.service";
        OnActiveSec = cfg.period;
        OnUnitActiveSec = cfg.period;
      };
    };
  };
}
