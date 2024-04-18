{ config, pkgs, ... }: {

  services = {
    dbus = {
      enable = true;
      packages = with pkgs; [ dconf ];
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    # portal.gtkUsePortal = true;
    # portal.extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
  };
}
