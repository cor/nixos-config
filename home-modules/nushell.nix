{ config, lib, theme, pkgs, pkgs-unstable, inputs, ... }:
{
  programs.nushell = {
    enable = true;
  };
}