{ config, pkgs, pkgs-unstable, lib, inputs, ... }:
{
  home.stateVersion = "22.05";

  home.packages = (with pkgs; [
    fzf
    git
    jq
    tree
    bottom
    fd
  ]) ++ (with pkgs-unstable; [ zellij ]);


  # Hide "last login" message on new terminal.
  home.file.".hushlogin".text = "";

  # programs.ssh doesn't work well for darwin.
  home.file.".ssh/config".text = ''
    Host *
      AddKeysToAgent yes
    Include ~/.orbstack/ssh/config
  '';
}
