{ pkgs, ... }:
{
  programs.niri.settings = {
    input.touchpad = {
      natural-scroll = true;
      accel-speed = 0.02;
      scroll-factor = 0.3;
      tap = false;
    };

    input.keyboard = {
      xkb = {
        options = "altwin:swap_alt_win,ctrl:nocaps";
      };

    };

    outputs."eDP-1".scale = 2.0;

    binds = {
      "Mod+T" = { action.spawn = "ghostty"; };
      "Mod+D" = { action.spawn = "fuzzel"; };
      "Mod+H" = { action.spawn = "focus-column-left"; };
      "Mod+J" = { action.spawn = "focus-window-down"; };
      "Mod+K" = { action.spawn = "focus-window-up"; };
      "Mod+L" = { action.spawn = "focus-column-right"; };
    };
  };
}
