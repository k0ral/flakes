{ config, pkgs ? import <nixpkgs> { }, ... }:

{
  systemd.user.services.wallabag = {
    Unit = {
      Description = "Wallabag";
      StartLimitInterval = 200;
      StartLimitBurst = 5;
    };
    Install = {
      WantedBy = [ "default.target" ];
      After = [ "podman.service" "podman.socket" ];
    };
    Service = {
      ExecStart =
        "${pkgs.docker-compose}/bin/docker-compose -f %h/services/wallabag/docker-compose.yaml up -d";
      # ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f %h/services/wallabag/docker-compose.yaml down";
      Environment = [ "DOCKER_HOST=unix:///run/user/%U/podman/podman.sock" ];
      # Restart = "always";
      # RestartSec = 30;
      # TimeoutStopSec = 70;
    };
  };
}
