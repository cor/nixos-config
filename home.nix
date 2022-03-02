{ config, pkgs, ... }:

{
  home-manager.users.cor = {
    home.file.".background-image".source = ./wallpapers/eclipse.jpg;

    gtk = {
      enable = true;
      # theme = {
      #    name = "Vertex-Dark";
      #    package = pkgs.theme-vertex;
      # };
    };

    programs.git = {
      enable = true;
      userName = "cor";
      userEmail = "cor@pruijs.dev";
      signing = {
        signByDefault = true;
        key = "06A6337C2BDD1365883C0668DB347466107E589F";
      };
    };
    programs.rofi = {
      enable = true;
      terminal = "${pkgs.kitty}/bin/kitty";
      theme = "/etc/nixos/rofi/theme.rafi";
    };
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
      ];
    };
    services.polybar = {
      enable = true;
      package = pkgs.polybar.override {
        mpdSupport = true;
        pulseSupport = true;
      };
      config = ./polybar/polybar.ini;
      script = ''
        polybar main &
      '';
    };

    xresources.properties = {
      "Xft.dpi" = 96;
    };
  };

}

