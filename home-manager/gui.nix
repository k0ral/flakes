{ config, pkgs ? import <nixpkgs> { }, ... }:

{
  imports = [
    ./dconf.nix
  ];

  gtk = {
    enable = true;
    font = {
      name = "Ubuntu";
      package = pkgs.ubuntu_font_family;
    };
    # theme.name = "Adwaita-dark";

    # gtk3.extraConfig = {
    #   gtk-application-prefer-dark-theme = 1;
    # };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };
}
