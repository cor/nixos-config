{ config, pkgs, ... }:
let
  makeCommand = command: {
    command = [ command ];
  };
in
{
  programs.niri.settings = {
    window-rules = [
      {
        # rule for hiding sensitive data in screenshares
        matches = [
          { app-id = "1Password"; }
          { app-id = "org.telegram.desktop"; }
          { app-id = "Element"; }
        ];
        block-out-from = "screen-capture";
      }
    ];
    input.touchpad = {
      natural-scroll = true;
      accel-speed = 0.02;
      scroll-factor = 0.3;
      tap = false;
    };
    spawn-at-startup = [
      (makeCommand "xwayland-satellite")
      (makeCommand "${pkgs.xdg-desktop-portal-gnome}/libexec/xdg-desktop-portal-gnome")
    ];

    environment = {
      DISPLAY = ":0";
      NIXOS_OZONE_WL = "1";
    };


    input.keyboard = {
      xkb = {
        options = "ctrl:nocaps";
      };
    };

    layout = {
      gaps = 16;
    };

    outputs."eDP-1".scale = 2.0;

    binds = with config.lib.niri.actions; {
      "Mod+T" = { action.spawn = "ghostty"; };
      "Mod+D" = { action.spawn = "fuzzel"; };

      # change focus -- window
      "Mod+H" = { action = focus-column-left; };
      "Mod+J" = { action = focus-window-down; };
      "Mod+K" = { action = focus-window-up; };
      "Mod+L" = { action = focus-column-right; };

      # change focus -- workspace
      "Mod+U" = { action = focus-workspace-down; };
      "Mod+I" = { action = focus-workspace-up; };

      # move windows
      "Mod+Ctrl+H" = { action = move-column-left; };
      "Mod+Ctrl+J" = { action = move-window-down; };
      "Mod+Ctrl+K" = { action = move-window-up; };
      "Mod+Ctrl+L" = { action = move-column-right; };

      # move columns -- workspace
      "Mod+Ctrl+U" = { action = move-column-to-workspace-down; };
      "Mod+Ctrl+I" = { action = move-column-to-workspace-up; };

      # move workspaces
      "Mod+Shift+U" = { action = move-workspace-down; };
      "Mod+Shift+I" = { action = move-workspace-up; };


      "Mod+R" = { action = switch-preset-column-width; };


      "Mod+F" = { action = maximize-column; };
      "Mod+Shift+F" = { action = fullscreen-window; };

      "Mod+V" = { action = toggle-window-floating; };

      "Mod+Q" = { action = close-window; };

      # "Mod+Shift+3" = { action = screenshot-screen; };
      "Mod+Shift+4" = { action = screenshot; };
    };
  };

  home.packages = [ pkgs.wl-clipboard ];

  # xresources.properties = {
  #   "Xft.dpi" = 192;
  # };

}
