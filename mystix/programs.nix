{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gnome3.adwaita-icon-theme
  ];

  programs = {
    adb.enable = true;
    dconf.enable = true;
    iftop.enable = true;
    kdeconnect.enable = true;
    light.enable = true;
    mosh.enable = true;
    mtr.enable = true;
    hyprland.enable = true;
    hyprland.xwayland.enable = false;
  };
}
