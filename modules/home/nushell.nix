{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let
  cfg = config.module.cli.nushell;
in {
  options.module.cli.nushell = {
    enable = mkEnableOption "nushell module";
  };

  config = mkIf cfg.enable {
    programs.carapace.enable = true;

    programs.nushell = {
      enable = true;

      envFile.text = ''
        $env.PATH = ($env.PATH | split row (char esep))
      '';

      configFile.text = ''
        hide http
        def ll [pattern: string = "."] { ls -l $pattern | reject inode num_links readonly | sort-by type }
        def df [...args: string] { sys | get disks }
        def sed [...args: string] { echo "use `sd` or `str replace` instead of `sed`" }

        $env.config = {
          show_banner: false

          completions: {
            quick: true
          }

          history: {
            max_size: 0
            sync_on_enter: false
          }

          keybindings: [{
            name: navi
            modifier: CONTROL
            keycode: Char_g
            mode: emacs
            event: [{
              send: executehostcommand,
              cmd: "commandline edit -r (navi --print)"
            }]
          },{
            name: fzf_file_path_fzf
            modifier: CONTROL
            keycode: Char_t
            mode: emacs
            event: [{
              send: executehostcommand,
              cmd: "commandline edit -i (fzf)"
            }]
          }]
        }
      '';

      environmentVariables = builtins.mapAttrs (k: v: ''"${v}"'') config.home.sessionVariables;
      shellAliases = config.home.shellAliases // {
        cat = "${pkgs.bat}/bin/bat";
        chmod = "chmod -c --preserve-root";
        cp = "cp -p -v";
        diff = "${pkgs.diffutils}/bin/diff --color=always";
        dmesg = "${pkgs.util-linuxCurses}/bin/dmesg -T";
        E = "sudoedit";
        find = "${pkgs.fd}/bin/fd";
        free = "${pkgs.procps}/bin/free -h";
        grep = "${pkgs.ripgrep}/bin/rg --hidden -g '!.git/'";
        la = "ls -la";
        less = "${pkgs.less}/bin/less -R";
        lsblk =
          "${pkgs.util-linuxCurses}/bin/lsblk -o NAME,LABEL,UUID,MODEL,SIZE,FSTYPE,MOUNTPOINT";
        mkdir = "mkdir -v";
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
  };
}
