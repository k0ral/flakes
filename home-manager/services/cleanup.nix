{ config, pkgs ? import <nixpkgs> { }, ... }:

let
  home = config.home.homeDirectory;
  cleanupScript = pkgs.writeShellScriptBin "cleanup-home" ''
    ${pkgs.detox}/bin/detox -r ${home}/Downloads ${home}/Desktop
    ${pkgs.coreutils}/bin/mv -v -n ${home}/Downloads/* ${home}/Desktop/* ${home}/
    ${pkgs.coreutils}/bin/rm -v -f -d ${home}/Downloads ${home}/Desktop
  '';
in {
  systemd.user.services.cleanup = {
    Unit.Description = "$HOME clean-up";
    Install.WantedBy = [ "default.target" ];

    Service = {
      Type = "oneshot";
      ExecStart = [ "${cleanupScript}/bin/cleanup-home" ];
    };
  };

  systemd.user.timers.cleanup = {
    Install.WantedBy = [ "timers.target" ];

    Timer = {
      Unit = "cleanup.service";
      OnBootSec = "3h";
      OnUnitActiveSec = "5h";
    };
  };
}
