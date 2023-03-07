{ config, lib, pkgs, pkgs-unstable, inputs, ... }:
{
  xdg.enable = true;
  home.stateVersion = "23.05";

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
    pinentry
    pinentry-curses
    pick-colour-picker
    bottom
    (writeShellScriptBin "xset-r-fast" ''
      xset r rate 150 40
    '')
    (writeShellScriptBin "xset-r-slow" ''
      xset r rate 250 30
    '')
  ] ++
  (with pkgs-unstable; [
    zellij
    vscode
    _1password-gui
    obsidian
    tdesktop
    element-desktop
  ]);

  home.file.".config/awesome".source = ./awesome;
  # Configure ranger to user kitty's image preview

  gtk = {
    enable = true;

    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };

    iconTheme = {
      package = pkgs.paper-icon-theme;
      name = "Paper";
    };
  };
  programs.rofi = import programs/rofi.nix pkgs;
  services.gpg-agent = import services/gpg-agent.nix;

  xsession.windowManager.awesome.enable = true;
  xresources.properties = let dpi = 192; in {
    "Xft.dpi" = dpi;
    "*.dpi" = dpi;
  };

}
