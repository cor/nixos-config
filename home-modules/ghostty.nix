{ ... }:
{
  # xdg.configFile."ghostty/config".text = ''
  #   macos-option-as-alt = true
  #   theme = catppuccin-frappe
  # '';
  programs.ghostty = {
    enable = true;
    settings = {
      window-decoration = "none";
      window-padding-color = "extend-always";
      # theme = "Ayu Mirage";
      font-size = 12;
    };
  };
}
