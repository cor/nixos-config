{ custom-packages, config, lib, pkgs, pkgs-unstable, inputs, ... }:
{
  home.packages = with pkgs; [
    bat # cat replacement
    binutils
    coreutils-full
    curl
    delta
    du-dust
    exa # ls replacement
    fd
    fzf
    gh
    gimp
    gnome3.gnome-control-center
    gping # ping with graph
    gtkmm3 # needed for the vmware user tools clipboard
    htop
    jq
    krita
    nixfmt
    openssh
    pamixer
    pick-colour-picker
    pinentry
    pinentry-curses
    ranger
    ripgrep
    tree
    watch
    wget
    xclip
    zip
    speedtest-cli # speedtest.net 
    custom-packages.current-task
    (writeShellScriptBin "xset-r-fast" ''
      xset r rate 150 40
    '')
    (writeShellScriptBin "xset-r-slow" ''
      xset r rate 350 20
    '')
  ] ++
  (with pkgs-unstable; [
    vscode
    bottom
    neofetch
    (_1password-gui.override ({ polkitPolicyOwners = [ "cor" ]; }))
    obsidian
    marksman
    tdesktop
    gomuks
    thunderbird
  ]);
}
