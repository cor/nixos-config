{ config, pkgs, lib, ... }:
let
  makeCommand = command: {
    command = [ command ];
  };
in
{
  programs.niri.settings = {


    workspaces = {
      "01-system" = {
        name = "system";
      };
      "02-audio" = {
        name = "audio";
      };
      "03-chat" = {
        name = "chat";
      };
      "04-notes" = {
        name = "notes";
      };
    };

    window-rules =
      let
        gather = "brave-pbjccpkpjiopbageefcniicfbjibmmaj-Default";
        element = "Element";
        telegram = "org.telegram.desktop";
        mail = "geary";
        discord = "brave-magkoliahgffibhgfkmoealggombgknl-Default";
        linear = "brave-bgdbmehlmdmddlgneophbcddadgknlpm-Default";
        slack = "brave-polomiencpcgedklffamlbmdolindfpb-Default";
        x-twitter = "brave-lodlkdfmihgonocnmddehnfgiljnadcf-Default";
        signal = "signal";

        apple-music = "brave-blgdilankhbcpipclgpdndahbehalgkh-Default";
        spotify = "brave-pjibgclleladliembfgfagdaldikeohf-Default";

        _1pw = "1Password";
        volume-control = "org.pulseaudio.pavucontrol";
        audio-effects = "com.github.wwmm.easyeffects";

        camera-preview = "guvcview";
        camera-preview-preview = ".guvcview-wrapped";

        epiphany = "org.gnome.Epiphany";
        obsidian = "obsidian";


        matchApp = app: { app-id = app; };
        matchApps = builtins.map matchApp;

        chatApps = [
          gather
          element
          telegram
          mail
          discord
          slack
          signal
          x-twitter
        ];
      in
      [
        {
          block-out-from = "screen-capture";
          matches = matchApps ([
            _1pw
            spotify
            apple-music
            epiphany
            obsidian
          ] ++ chatApps);
        }
        {
          geometry-corner-radius = let radius = 10.0; in {
            bottom-left = radius;
            bottom-right = radius;
            top-left = radius;
            top-right = radius;
          };
          clip-to-geometry = true;
          border.width = lib.mkForce 2;
        }
        {
          open-on-workspace = "chat";
          matches = matchApps chatApps;
        }
        {
          open-on-workspace = "system";
          matches = matchApps [
            _1pw
            camera-preview
            camera-preview-preview
          ];
        }
        {
          open-on-workspace = "audio";
          matches = matchApps [
            volume-control
            audio-effects
            spotify
            apple-music
          ];
        }
        {
          open-on-workspace = "notes";
          matches = matchApps [
            linear
            obsidian
            epiphany
          ];
        }
      ];

    input = {
      touchpad = {
        natural-scroll = true;
        accel-speed = 0.02;
        scroll-factor = 0.3;
        tap = false;
      };
      keyboard = {
        xkb = {
          options = "ctrl:nocaps";
        };
        repeat-rate = 40;
        repeat-delay = 250;
      };
    };

    outputs = {
      "Apple Computer Inc ProDisplayXDR 0x2E121A08" = {
        position = {
          x = 1440;
          y = 0;
        };
      };
      "Nreal XREAL One Pro Unknown" = {
        scale = 1.25;
        position = {
          x = -560;
          y = -354;
        };
      };
      # Framework built in display
      "BOE NE135A1M-NY1 Unknown" = {
        position = {
          x = 0;
          y = 366;
        };
      };
    };

    overview = {
      zoom = 0.3;
    };

    spawn-at-startup = [
      (makeCommand "xwayland-satellite")
      (makeCommand "${pkgs.xdg-desktop-portal-gnome}/libexec/xdg-desktop-portal-gnome")
    ];

    environment = {
      DISPLAY = ":0";
      NIXOS_OZONE_WL = "1";
    };

    layout = {
      gaps = 16;
      focus-ring = {
        # active = { color = "rgb(166, 112, 219)"; };
        width = lib.mkForce 1;
      };
      preset-column-widths = [
        { proportion = 1. / 4.; }
        { proportion = 1. / 3.; }
        { proportion = 1. / 2.; }
        { proportion = 2. / 3.; }
      ];
    };

    outputs."eDP-1".scale = 2.0;

    switch-events.lid-close.action.spawn = "swaylock";
    screenshot-path = "~/Pictures/Screenshots/screenshot-%Y-%m-%dT%H:%M:%S.png";

    binds = with config.lib.niri.actions; {
      "Mod+T" = { action = toggle-column-tabbed-display; };
      "Mod+Return" = { action.spawn = "ghostty"; };
      "Mod+Space" = { action.spawn = "fuzzel"; };
      "Mod+Tab" = { action = toggle-overview; };

      # change focus -- window
      "Mod+H" = { action = focus-column-left; };
      "Mod+J" = { action = focus-window-down; };
      "Mod+K" = { action = focus-window-up; };
      "Mod+L" = { action = focus-column-right; };

      # change focus -- workspace
      "Mod+U" = { action = focus-workspace-down; };
      "Mod+I" = { action = focus-workspace-up; };

      # change focus -- monitor
      "Mod+Alt+H" = { action = focus-monitor-left; };
      "Mod+Alt+L" = { action = focus-monitor-right; };

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
      "Mod+Shift+H" = { action = move-workspace-to-monitor-left; };
      "Mod+Shift+J" = { action = move-workspace-to-monitor-down; };
      "Mod+Shift+K" = { action = move-workspace-to-monitor-up; };
      "Mod+Shift+L" = { action = move-workspace-to-monitor-right; };


      "Mod+R" = { action = switch-preset-column-width; };


      "Mod+F" = { action = maximize-column; };
      "Mod+Shift+F" = { action = fullscreen-window; };

      "Mod+V" = { action = toggle-window-floating; };

      "Mod+Q" = { action = close-window; };

      "Mod+Alt+P".action.spawn = "swaylock";

      "Mod+C" = { action = center-column; };

      "Mod+Shift+4" = { action = screenshot; };
      # "Mod+Shift+4" = { action.spawn = "cor-screenshot"; };


      # volume control
      "XF86AudioRaiseVolume" = { allow-when-locked = true; action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+" ]; };
      "XF86AudioLowerVolume" = { allow-when-locked = true; action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-" ]; };
      "XF86AudioMute" = { allow-when-locked = true; action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ]; };
      "XF86AudioMicMute" = { allow-when-locked = true; action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ]; };

      # brithness control
      "XF86MonBrightnessUp" = {
        allow-when-locked = true;
        action.spawn = [ "brightnessctl" "set" "+5%" ];
      };

      "XF86MonBrightnessDown" = {
        allow-when-locked = true;
        action.spawn = [ "brightnessctl" "set" "5%-" ];
      };

      # media controls
      "XF86AudioPlay" = {
        allow-when-locked = true;
        action.spawn = [ "playerctl" "play-pause" ];
      };

      "XF86AudioNext" = {
        allow-when-locked = true;
        action.spawn = [ "playerctl" "next" ];
      };

      "XF86AudioPrev" = {
        allow-when-locked = true;
        action.spawn = [ "playerctl" "previous" ];
      };
    };
  };

  home.packages = [ pkgs.wl-clipboard ];

  systemd.user.services."swaybg" = {
    Unit = {
      Description = "wallpapers! brought to you by stylix!";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${lib.getExe pkgs.swaybg} -m fill -i ${config.stylix.image}";
      Restart = "on-failure";
    };
  };

}
