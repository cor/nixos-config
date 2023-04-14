{ config, lib, pkgs, pkgs-unstable, inputs, ... }:
{
  home.packages = with pkgs; [
    bat # cat replacement
    exa # ls replacement
    gping # ping with graph
    gh
    fd
    thunderbird
    fzf
    htop
    jq
    ripgrep
    ranger
    tree
    watch
    openssh
    zip
    curl
    delta
    pamixer
    wget
    coreutils-full
    binutils
    gnome3.gnome-control-center
    xclip
    gtkmm3 # needed for the vmware user tools clipboard
    neofetch
    nixfmt
    neovim
    pinentry
    pinentry-curses
    pick-colour-picker
    bottom
    (writeShellScriptBin "xset-r-fast" ''
      xset r rate 150 40
    '')
    (writeShellScriptBin "xset-r-slow" ''
      xset r rate 350 20
    '')
  ] ++
  (with pkgs-unstable; [
    zellij
    vscode
    (_1password-gui.override ({ polkitPolicyOwners = ["cor"]; }))    
    obsidian
    tdesktop
  ]);
}
