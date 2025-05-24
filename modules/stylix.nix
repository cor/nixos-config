{ pkgs, lib, pkgs-unstable, ... }:
{
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    image = ../wallpapers/leaves.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/danqing.yaml";
    fonts = {
      sansSerif = {
        package = pkgs-unstable.inter;
        name = "Inter";
      };
      monospace = {
        package = pkgs-unstable.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMonoNerdFont";
      };
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
    };
  };

  # idk man
  # https://github.com/TheColorman/nixcfg/blob/1ab6dea79266123713d0d59ab332c9683472c85d/utils/stylix/default.nix#L52
  system.activationScripts.fix_stylix.text = ''
    rm /home/color/.gtkrc-2.0 -f
  '';

  # Fix for inconsistent cursor size and theme in X11/Xwayland apps
  environment.variables = {
    XCURSOR_SIZE = "20";
    XCURSOR_THEME = "Bibata-Modern-Classic";
  };

  specialisation.light.configuration = {
    stylix = {
      image = lib.mkForce ../wallpapers/tiger.jpg;
      polarity = lib.mkForce "light";
      # base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/default-light.yaml";
      # better than cupertino ^
      # base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/da-one-white.yaml";
      base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/one-light.yaml";
      # base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/tomorrow.yaml";
    };
  };
}
