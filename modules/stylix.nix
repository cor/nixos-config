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

  };

  # idk man
  # https://github.com/TheColorman/nixcfg/blob/1ab6dea79266123713d0d59ab332c9683472c85d/utils/stylix/default.nix#L52
  system.activationScripts.fix_stylix.text = ''
    rm /home/color/.gtkrc-2.0 -f
  '';



  specialisation.light.configuration = {
    stylix = {
      image = lib.mkForce ../wallpapers/tiger.jpg;
      polarity = lib.mkForce "light";
      base16Scheme = lib.mkForce "${pkgs.base16-schemes}/share/themes/nord-light.yaml";
    };
  };
}


