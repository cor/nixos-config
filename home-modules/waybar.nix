{ pkgs, ... }:
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
        modules-right = [ "network" "battery" "power-profiles-daemon" "clock" ];
        battery = {
          format = "{capacity}%";
        };
        clock = {
          format-alt = "{:%a, %d. %b  %H:%M}";
        };
        network = {
          "format" = "{ifname}";
          "format-wifi" = "{icon} ";
          "format-ethernet" = "󰌘";
          "format-disconnected" = "󰌙";
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
      systemd = {
        enable = true;
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
  };
}

