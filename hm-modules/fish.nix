{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let cfg = config.module.cli.fish;
in {
  options.module.cli.fish = { enable = mkEnableOption "Fish module"; };

  config = mkIf cfg.enable {
    programs.eza.enable = true;

    programs.fish = {
      enable = true;

      plugins = [
        {
          name = "autopair";
          src = pkgs.fetchFromGitHub {
            owner = "jorgebucaran";
            repo = "autopair.fish";
            rev = "1.0.4";
            sha256 = "sha256-s1o188TlwpUQEN3X5MxUlD/2CFCpEkWu83U9O+wg3VU=";
          };
        }

        {
          name = "fzf";
          src = pkgs.fetchFromGitHub {
            owner = "PatrickF1";
            repo = "fzf.fish";
            rev = "v9.0";
            sha256 = "sha256-0rnd8oJzLw8x/U7OLqoOMQpK81gRc7DTxZRSHxN9YlM=";
          };
        }
      ];

      shellInit = ''
        function cd
            builtin cd $argv; and ls
        end

        function up
            for i in (seq 1 $argv)
              cd ..
            end
        end

        set fish_greeting ""
      '';
    };

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
      ls = "${pkgs.eza}/bin/eza -g --group-directories-first";
      lsblk =
        "${pkgs.util-linuxCurses}/bin/lsblk -o NAME,LABEL,UUID,MODEL,SIZE,FSTYPE,MOUNTPOINT";
      mkdir = "mkdir -p -v";
      mv = "mv -v";
      ping = "${pkgs.trippy}/bin/trip";
      rename = "${pkgs.util-linuxCurses}/bin/rename -v";
      o = "${pkgs.xdg-utils}/bin/xdg-open";
      pstree = "${pkgs.pstree}/bin/pstree -p -T -a";
      rm = "rm -v";
      s = "sudo";
      sshfs = "${pkgs.sshfs}/bin/sshfs -o follow_symlinks";
      syslog = "${pkgs.systemd}/bin/journalctl -u";
      syslogu = "${pkgs.systemd}/bin/journalctl --user-unit";
      sysdu = "${pkgs.systemd}/bin/systemctl --user";
      watch = "${pkgs.procps}/bin/watch -c";
      wget = "${pkgs.wget}/bin/wget -c";
    };

  };
}
