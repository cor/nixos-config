{ ... }:
{
  # xdg.configFile."ghostty/config".text = ''
  #   macos-option-as-alt = true
  #   theme = catppuccin-frappe
  # '';
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        modules-left = [ "niri/workspaces" ];
        modules-right = [ "network" "power-profiles-daemon" "battery" "backlight" "wireplumber" "clock" ];
        battery.format = "{capacity}";
        backlight.format = "{percent}";
        wireplumber.format = "{volume}";
        clock = {
          format-alt = "{:%a, %d. %b  %H:%M}";
        };
        network = {
          "format" = "{ifname}";
          "format-wifi" = "{icon} ";
          "format-ethernet" = "󰌘 ";
          "format-disconnected" = "󰌙 ";
          "tooltip-format" = "{ipaddr}  {bandwidthUpBits}  {bandwidthDownBits}";
          "format-linked" = "󰈁 {ifname} (No IP)";
          "tooltip-format-wifi" = "{essid} {icon} {signalStrength}%";
          "tooltip-format-ethernet" = "{ifname} 󰌘";
          "tooltip-format-disconnected" = "󰌙 Disconnected";
          "max-length" = 30;
          "format-icons" = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          "on-click-right" = "ghostty -e nmtui";
        };

        "power-profiles-daemon" = {
          "format" = "{icon} ";
          "tooltip-format" = "Power profile: {profile}\nDriver: {driver}";
          "tooltip" = true;
          "format-icons" = {
            "default" = "";
            "performance" = "";
            "balanced" = "";
            "power-saver" = "";
          };
        };
      };
      # style = ''
      #   ${builtins.readFile "${pkgs.waybar}/etc/xdg/waybar/style.css"}

      #   * {
      #     font-family: "JetBrainsMono Nerd Font";
      #   }

      #   window#waybar {
      #     border-bottom: none;
      #   }
      # '';
    };

    systemd = {
      enable = true;
      target = "niri.service";
    };

    # Override default stylix styling for waybar
    style =
      # css
      ''
        .modules-left {
          padding-left: 8px;
        }
        .modules-right {
          padding-right: 8px;
        }
        
        /* Use stylix colors but override specific element styles */
        #workspaces button {
          border-radius: 0;
          padding: 2px 8px;
        }
      
        #workspaces button.focused {
          border-radius: 0;
        }
      
        #workspaces button.active {
          border-radius: 0;
        }
      
        #workspaces button.urgent {
          border-radius: 0;
        }
      
        #workspaces button:hover {
          border-radius: 0;
        }

        #clock {
          font-weight: bold;
        }
      '';
  };
}

