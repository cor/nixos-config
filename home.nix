{ config, pkgs, ... }:

{
  home-manager.users.cor = {
    programs.git = {
      enable = true;
      userName = "cor";
      userEmail = "cor@pruijs.dev";
    };
  };
}
