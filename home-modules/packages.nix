{ custom-packages, config, lib, pkgs, pkgs-unstable, inputs, ... }:
{
  home.packages = with pkgs; [
    bat # cat replacement
    binutils
    coreutils-full
    curl
    delta
    du-dust
    fd
    fzf
    gnome3.gnome-control-center
    gping # ping with graph
    gtkmm3 # needed for the vmware user tools clipboard
    htop
    krita
    nnn
    pamixer
    pick-colour-picker
    pinentry
    pinentry-curses
    ripgrep
    tree
    watch
    wget
    xclip
    zip
  ] ++
  (with pkgs-unstable; [
    openssh
    gh
    jq
    bottom
    marksman
    neofetch
    obsidian
    vscode
  ])
  ++
  (with custom-packages; [
    current-task
    xset-r-fast
    xset-r-slow
    set-theme
  ]);
}
