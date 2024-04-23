{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let cfg = config.module.audio.beets;
in {
  options.module.audio.beets = {
    enable = mkEnableOption "Beets module";
    directory = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable {
    programs.beets = {
      enable = true;
      settings = {
        directory = cfg.directory;
        library = "${config.xdg.configHome}/beets/library.blb";
        plugins = "acousticbrainz chroma fromfilename lastgenre duplicates replaygain";

        import = {
          asciify_paths = true;
          copy = false;
          none_rec_action = "skip";
          duplicate_action = "keep";
          group_albums = true;
        };

        asciify_paths = true;

        paths = {
          default = "%lower{albums/$album%aunique{}/$title}";
          singleton = "%lower{%if{$album,albums/$album%aunique{},standalones/$artist}/$title%sunique{}}";
          comp = "%lower{compilations/$album%aunique{}/$title}";
        };

        match = {
          strong_rec_thresh = 0.10;
        };

        duplicates = {
          keys = [ "acoustid_fingerprint" ];
          path = true;
          strict = true;
        };

        replaygain = {
          backend = "gstreamer";
        };
      };
    };
  };
}
