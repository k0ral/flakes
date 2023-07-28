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

    home.shellAliases = {
      cat = "${pkgs.bat}/bin/bat";
      chmod = "chmod -c --preserve-root";
      cp = "${pkgs.rsync}/bin/rsync -av --progress";
      diff = "${pkgs.diffutils}/bin/diff --color=always";
      df = "${pkgs.lfs}/bin/dysk";
      dmesg = "${pkgs.util-linuxCurses}/bin/dmesg -T";
      E = "sudoedit";
      find = "${pkgs.fd}/bin/fd";
      free = "${pkgs.procps}/bin/free -h";
      grep = "${pkgs.ripgrep}/bin/rg --hidden -g '!.git/'";
      la = "ls -la";
      less = "${pkgs.less}/bin/less -R";
      ll = "ls -l --icons";
      ls = "${pkgs.exa}/bin/exa -g --group-directories-first";
      lsa = "ls -a";
      lsblk =
        "${pkgs.util-linuxCurses}/bin/lsblk -o NAME,LABEL,UUID,MODEL,SIZE,FSTYPE,MOUNTPOINT";
      mkdir = "mkdir -p -v";
      mv = "mv -v";
      ping = "${pkgs.prettyping}/bin/prettyping --nolegend";
      rename = "${pkgs.util-linuxCurses}/bin/rename -v";
      o = "${pkgs.xdg-utils}/bin/xdg-open";
      pstree = "${pkgs.pstree}/bin/pstree -p -T -a";
      rm = "rm -v";
      s = "sudo";
      sshfs = "${pkgs.sshfs}/bin/sshfs -o follow_symlinks";
      sys = "${pkgs.systemd}/bin/systemctl";
      syslog = "${pkgs.systemd}/bin/journalctl --follow -u";
      syslogu = "${pkgs.systemd}/bin/journalctl --follow --user-unit";
      sysu = "${pkgs.systemd}/bin/systemctl --user";
      watch = "${pkgs.procps}/bin/watch -c";
      wget = "${pkgs.wget}/bin/wget -c";
    };

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
      exa.enable = true;
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
