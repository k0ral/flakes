{ config, lib, pkgs ? import <nixpkgs> { }, ... }:
with lib;

let cfg = config.module.web.librewolf;
in {
  options.module.web.librewolf = {
    enable = mkEnableOption "Librewolf module";
  };

  config = mkIf cfg.enable {
    programs.librewolf = {
      enable = true;
      package = pkgs.librewolf-wayland;
      settings = {
        "identity.fxaccounts.enabled" = true;
        "webgl.disabled" = false;
      };
    };

    xdg.mimeApps.enable = true;
    xdg.mimeApps.defaultApplications = {
      "text/html" = [ "librewolf.desktop" ];
      "x-scheme-handler/http" = [ "librewolf.desktop" ];
      "x-scheme-handler/https" = [ "librewolf.desktop" ];
    };
  };
}
