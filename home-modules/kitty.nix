{ isDarwin, pkgs-unstable, ... }: 
{
  programs.kitty = {
    enable = true;
    package = pkgs-unstable.kitty;
    settings = {
      scrollback_lines = 1000000;
      enable_audio_bell = false;
      update_check_interval = 0;
      wheel_scroll_multiplier = 1;
      wheel_scroll_min_lines = 1;
      touch_scroll_multiplier = 1;
      confirm_os_window_close = 0;
      shell_integration = "enabled";
      macos_option_as_alt = true;
      tab_bar_min_tabs = 1;
      tab_title_template = "{title}";
      active_tab_title_template = "{title} - {num_windows} {layout_name}";
      tab_bar_edge = "top";
      tab_bar_style = "slant";
      tab_bar_align = "center";
      tab_activity_symbol = "◉";
    };
    font = {
      size = if isDarwin then 16 else 12; # physically equivalent
      name = "JetBrains Mono";
    };
    keybindings = {
      "kitty_mod+n" = "new_window_with_cwd";
    } // (if isDarwin then {
      "cmd+enter" = "new_window_with_cwd";
      "cmd+j" = "next_window";
      "cmd+shift+j" = "move_window_forward";
      "cmd+k" = "previous_window";
      "cmd+shift+k" = "move_window_backward";
      "cmd+shift+r" = "set_tab_title";
      "cmd+p" = "next_layout";
      "cmd+o" = "toggle_layout stack"; # temporarily maximize a window
    } else {
      "super+shift+enter" = "new_os_window_with_cwd";
      "alt+enter" = "new_window_with_cwd";
      "alt+w" = "close_window";
      "alt+j" = "next_window";
      "alt+t" = "new_tab";
      "alt+]" = "next_tab";
      "alt+[" = "previous_tab";
      "alt+k" = "previous_window";
      "alt+shift+k" = "move_window_backward";
      "alt+r" = "start_resizing_window";
      "alt+shift+r" = "set_tab_title";
      "alt+p" = "next_layout";
      "alt+o" = "toggle_layout stack"; # temporarily maximize a window
    });
    theme = "Ayu Mirage";
  };
}