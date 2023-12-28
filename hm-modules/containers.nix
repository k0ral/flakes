{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let
  cfg = config.module.dev.containers;
in {
  options.module.dev.containers = {
    enable = mkEnableOption "Containers module";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dive
      docker-compose
      lazydocker
    ];

    home.sessionVariables.DOCKER_HOST = "unix://${config.home.sessionVariables.XDG_RUNTIME_DIR}/podman/podman.sock";
    home.shellAliases.dc = "docker-compose";
  };
}
