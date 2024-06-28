{ config, lib, pkgs ? import <nixpkgs> { }, network, ... }:

{
  home.packages = with pkgs; [ borgbackup ];

  programs.borgmatic = {
    enable = true;
    backups.main = {
      location = {
        sourceDirectories = [
          "${config.home.homeDirectory}/age-of-ashes"
          "${config.home.homeDirectory}/digital-garden"
          "${config.home.homeDirectory}/doc"
          "${config.home.homeDirectory}/finance"
          "${config.home.homeDirectory}/flakes"
          "${config.home.homeDirectory}/foundry"
          "${config.home.homeDirectory}/images"
          "${config.home.homeDirectory}/logseq"
          "${config.home.homeDirectory}/papers"
          "${config.home.homeDirectory}/prog/archive"
          "${config.home.homeDirectory}/services"
          "${config.home.homeDirectory}/.gnupg"
          "${config.home.homeDirectory}/.mozilla"
          "${config.home.homeDirectory}/.password-store"
          "${config.home.homeDirectory}/.thunderbird"
          "${config.xdg.configHome}"
          "${config.xdg.dataHome}/buku"
          "${config.xdg.dataHome}/shiori"
        ];
        repositories = [{
          path = "ssh://17994@ch-s011.rsync.net/./backup";
          label = "rsync.net";
        }];
        extraConfig = {
          remote_path = "borg1";
        };
      };
      retention.keepDaily = 30;
      storage.encryptionPasscommand = ''
        ${pkgs.coreutils}/bin/cat ${config.xdg.configHome}/sops-nix/secrets/rsync.net/borg-passphrase
      '';
      hooks.extraConfig.ntfy = {
        topic = "borgmatic";
        server = "http://${network.homeLAN.regis.ipv4}:9876";

        start = {
            title = "A borgmatic backup started";
            message = "Watch this space...";
            tags = "borgmatic";
            priority = "min";
        };
        finish = {
            title = "A borgmatic backup completed successfully";
            message = "Nice!";
            tags = "borgmatic,+1";
            priority = "min";
        };
        fail = {
            title = "A borgmatic backup failed";
            message = "You should probably fix it";
            tags = "borgmatic,-1,skull";
            priority = "max";
        };
        states = ["start" "finish" "fail" ];
      };
    };
  };

  services.borgmatic = {
    enable = true;
    frequency = "daily";
  };

  sops.secrets."rsync.net/borg-passphrase" = {};
}
