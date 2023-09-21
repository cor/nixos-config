{ pkgs, theme, ... }:
{
  gtk = {
    enable = true;

    theme = {
      package = pkgs.arc-theme;
      name = if theme == "dark" then "Arc-Dark" else "Arc";
    };

    iconTheme = {
      package = pkgs.paper-icon-theme;
      name = "Paper";
    };
  };
}
