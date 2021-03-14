{ config, pkgs, ... }:

let
    homeDirectory = "/home/cor";
in
{
    imports = [
      ./modules/git.nix
    ];

    xdg = {
      enable = true;
      configHome = "${homeDirectory}/.config";
      dataHome = "${homeDirectory}/.local/share";
      cacheHome = "${homeDirectory}/.cache";
      userDirs = {
        desktop = "\$HOME";
        documents = "\$HOME";
      };
    };


    home.username = "cor";
    home.homeDirectory = homeDirectory;
    home.language.base = "en_US.UTF-8";
    home.stateVersion = "20.09";
    
    programs.home-manager.enable = true;
}
