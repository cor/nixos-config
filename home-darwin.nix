{ config, pkgs, lib, inputs, ...}:
{
  home.stateVersion = "22.05";    
  
  home.packages = with pkgs; [
    cachix
    lazygit
  ];
  
  programs.helix = import programs/helix.nix inputs.helix.packages.${pkgs.system}.default;
  programs.kitty = import programs/kitty.nix;
}
