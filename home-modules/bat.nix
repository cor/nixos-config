{ config, lib, theme, pkgs, pkgs-unstable, inputs, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = if theme == "light" then "OneHalfLight" else "OneHalfDark";
    };
  };
}