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
      ForwardAgent yes
      AddKeysToAgent yes
      IdentityAgent $SSH_AUTH_SOCK
  '';
}
