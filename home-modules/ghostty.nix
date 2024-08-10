{ ... }:
{
  xdg.configFile."ghostty/config".text = ''
    macos-titlebar-style = transparent
    macos-option-as-alt = true
    theme = catppuccin-frappe
    font-family = JetBrains Mono
    background-opacity = 0.8
    background-blur-radius = 20
  '';
}
