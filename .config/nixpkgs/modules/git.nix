{ pkgs, ... }:

{
    programs.git = {
      enable = true;
      userName = "cor";
      userEmail = "cor@pruijs.nl";
      
      extraConfig = {
        credential.helper = "cache";
      };
    };
}
