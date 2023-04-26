{ pkgs-unstable, ... }:
{
    home.stateVersion = "23.05";
    xdg.enable = true;
    xresources.properties = let dpi = 192; in {
      "Xft.dpi" = dpi;
      "*.dpi" = dpi;
    };

    home.pointerCursor = {
      name = "macOS-Monterey";
      package = pkgs-unstable.apple-cursor;
      size = 48;
      x11.enable = true;
      gtk.enable = true;
    };
    
}