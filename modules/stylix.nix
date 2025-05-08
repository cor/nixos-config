{ pkgs, pkgs-unstable, ... }:
{
  stylix = {
    enable = true;
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
  };
}


