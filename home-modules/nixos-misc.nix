{ ... }:
{
    home.stateVersion = "23.05";
    xdg.enable = true;
    xresources.properties = let dpi = 192; in {
      "Xft.dpi" = dpi;
      "*.dpi" = dpi;
    };
}