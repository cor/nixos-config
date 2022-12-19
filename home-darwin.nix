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
    bat
  ];
  
  programs.git = import programs/git.nix;
  programs.gpg = import programs/gpg.nix;
  programs.zsh = import programs/zsh.nix;
  programs.kitty = import programs/kitty.nix { isDarwin = true; };
  programs.helix = import programs/helix.nix inputs.helix.packages.${pkgs.system}.default;
  
  # Hide "last login" message on new terminal.
  home.file.".hushlogin".text = "";
     
  # programs.ssh doesn't work well for darwin.
  home.file.".ssh/config".text = ''
    Host *
      AddKeysToAgent yes
      UseKeychain yes
      IdentityFile ~/.ssh/id_ed25519_2022-12-19  
  '';
}
