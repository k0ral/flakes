{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let cfg = config.module.essential.core;
in {
  options.module.essential.core = {
    enable = mkEnableOption "Essential core tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      acpi
      cryptsetup
      fd
      file
      inetutils
      ldns
      lfs
      lsof
      moreutils
      nmap
      pciutils
      ripgrep
      rmlint
      rsync
      sd
      smartmontools
      sshfs-fuse
      usbutils
      utillinux
      xdg_utils
      wget
    ];


    news.display = "silent";

    programs = {
      aria2.enable = true;
      aria2.extraConfig = ''
        max-tries=0
        retry-wait=10
        dir=${config.home.homeDirectory}/
        save-session=${config.xdg.configHome}/aria2/session
        save-session-interval=30
        download-result=full
      '';
      bat.enable = true;
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      fzf.enable = true;
      home-manager.enable = true;
      man.enable = true;
      navi = {
        enable = true;
        settings.cheats.paths = [ "${config.xdg.configHome}/navi/cheats" ];
      };
      starship = {
        enable = true;
        settings = {
          add_newline = false;
          directory = {
            truncation_length = 0;
            truncate_to_repo = false;
          };
          hostname.ssh_only = false;
          username.show_always = true;
          git_status.disabled = true;
        };
      };
      tealdeer.enable = true;
    };
  };
}
