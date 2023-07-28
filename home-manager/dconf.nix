{ config, pkgs ? import <nixpkgs> {}, ... }:

{
  dconf = {
    enable = true;
    # settings = {
    #   "org/gnome/desktop/interface" = {
    #     gtk-theme = "Adwaita-dark";
    #   };
    # };
    # font = {
    #   name = "Ubuntu";
    #   package = pkgs.ubuntu_font_family;
    # };

    # gtk3.extraConfig = {
    #   gtk-application-prefer-dark-theme = 1;
    # };
  };

  home.packages = with pkgs; [
      gnome3.dconf-editor
  ];
}

