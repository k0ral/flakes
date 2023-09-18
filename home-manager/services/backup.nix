{ config, lib, pkgs ? import <nixpkgs> { }, ... }:

let
  borg-paths = [
    "${config.home.homeDirectory}/digital-garden"
    "${config.home.homeDirectory}/doc"
    "${config.home.homeDirectory}/finance"
    "${config.home.homeDirectory}/flakes"
    "${config.home.homeDirectory}/foundry"
    "${config.home.homeDirectory}/images"
    "${config.home.homeDirectory}/papers"
    "${config.home.homeDirectory}/prog/archive"
    "${config.home.homeDirectory}/services"
    "${config.home.homeDirectory}/.librewolf"
    "${config.home.homeDirectory}/.local/share/gtg"
    "${config.home.homeDirectory}/.password-store"
    "${config.home.homeDirectory}/.thunderbird"
    "${config.xdg.configHome}"
  ];
  backupScript = pkgs.writeShellScriptBin "backup" ''
    export BORG_PASSCOMMAND="${pkgs.coreutils}/bin/cat ${config.xdg.configHome}/secrets/borg-passphrase"
    REPOSITORY=$(${pkgs.coreutils}/bin/cat ${config.xdg.configHome}/secrets/borg-repository)

    ${pkgs.borgbackup}/bin/borg create --remote-path=borg1 -x -C lzma "$REPOSITORY:backup::{utcnow}-{hostname}" ${lib.strings.concatStringsSep " " borg-paths}
    ${pkgs.borgbackup}/bin/borg prune --remote-path=borg1 -d 30 "$REPOSITORY:backup"
  '';
in {
  home.packages = with pkgs; [ borgbackup ];

  systemd.user.services.backup = {
    Unit.Description = "Backup";
    Install.WantedBy = [ "default.target" ];

    Service = {
      ExecStart = [ "-${backupScript}/bin/backup" ];

      Type = "oneshot";
    };
  };

  systemd.user.timers.backup = {
    Install.WantedBy = [ "timers.target" ];

    Timer = {
      Unit = "backup.service";
      OnCalendar = "daily";
    };
  };
}
