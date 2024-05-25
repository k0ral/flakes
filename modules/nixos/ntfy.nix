{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let cfg = config.module.nixos.ntfy;
in {
  options.module.nixos.ntfy = {
    enable = mkEnableOption "ntfy module";
    host = mkOption { type = types.str; };
    port = mkOption { type = types.int; };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "http://${cfg.host}:${builtins.toString cfg.port}";
        listen-http = ":${builtins.toString cfg.port}";
        attachment-cache-dir = "/var/lib/ntfy-sh/attachment-cache";
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/ntfy-sh/attachment-cache 0777 ${config.services.ntfy-sh.user} ${config.services.ntfy-sh.group}"
    ];
  };
}
