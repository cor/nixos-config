{ ... }:
{
  xdg.configFile."ghostty/config".text = ''
    macos-titlebar-style = hidden
    macos-option-as-alt = true
    theme = catppuccin-frappe
    font-family = JetBrains Mono
    background-opacity = 0.85
    background-blur-radius = 20
    window-padding-color = extend
  '';
}
