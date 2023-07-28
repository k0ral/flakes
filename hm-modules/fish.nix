{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let cfg = config.module.cli.fish;
in {
  options.module.cli.fish = { enable = mkEnableOption "Fish module"; };

  config = mkIf cfg.enable {
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
  };
}
