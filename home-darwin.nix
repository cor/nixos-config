{ config, pkgs, lib, ...}:

{
  home.stateVersion = "22.05";    
  
  home.packages = with pkgs; [
    cachix
    lazygit
  ];
}
