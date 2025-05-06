{ pkgs, ... }:
{
  stylix = {
    enable = true;
    polarity = "dark";
    image = ../wallpapers/leaves.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/danqing.yaml";
  };
}


