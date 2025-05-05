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
        modules-right = [ "network" "battery" "clock" ];
        battery = {
          format = "{capacity}%";
        };
        clock = {
          format-alt = "{:%a, %d. %b  %H:%M}";
        };
        network = {
          "format" = "{ifname}";
          "format-wifi" = "{icon}";
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
      };
      systemd.enable = true;
    };
  };
}

