{ config, pkgs, lib, inputs, ...}:
{
  home.stateVersion = "22.05";    
  
  home.packages = with pkgs; [
    cachix
    lazygit
    fzf
  ];
  
  programs.zsh = import programs/zsh.nix;
  programs.kitty = import programs/kitty.nix;
  programs.helix = import programs/helix.nix inputs.helix.packages.${pkgs.system}.default;
}
