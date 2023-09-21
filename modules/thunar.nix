{ inputs, pkgs, ... }:
{
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
}
