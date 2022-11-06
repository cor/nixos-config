{ config, pkgs, lib, inputs, ...}:
{
  home.stateVersion = "22.05";    
  
  home.packages = with pkgs; [
    cachix
    lazygit
    fzf
    git
    git-lfs
    exa
  ];
  
  programs.git = import programs/git.nix;
  programs.gpg = import programs/gpg.nix;
  programs.zsh = import programs/zsh.nix;
  programs.kitty = import programs/kitty.nix;
  programs.helix = import programs/helix.nix inputs.helix.packages.${pkgs.system}.default;
}
