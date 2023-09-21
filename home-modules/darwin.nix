{ config, pkgs, lib, inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.system; config.allowUnfree = true; };
in
{
  home.stateVersion = "22.05";

  home.packages = (with pkgs; [
    cachix
    fzf
    git
    git-lfs
    exa
    bat
    jq
    tree
    bottom
  ]) ++ (with pkgs-unstable; [ zellij youtube-dl ]);


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
