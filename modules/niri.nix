{ pkgs, ... }:
{
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
  # programs.gnome-keyring.enable = true;
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    configPackages = [ pkgs.gnome-session ];
    extraPortals = [ pkgs.xdg-desktop-portal-gnome pkgs.xdg-desktop-portal-gtk pkgs.gnome-keyring ];
    config.niri = {
      default = "gnome;gtk;";
      "org.freedesktop.impl.portal.Access" = "gtk";
      "org.freedesktop.impl.portal.Notification" = "gtk";
      "org.freedesktop.impl.portal.OpenURI" = "gtk";
      "org.freedesktop.impl.portal.FileChooser" = "gtk";
      "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
    };
    xdgOpenUsePortal = true;
  };
  services.gnome.gnome-keyring.enable = true;
}
