{ isDarwin, pkgs, theme, ... }: 
{
  programs.kitty = {
    enable = false;
    package = pkgs.kitty;
    settings = {
      enabled_layouts = "fat:bias=70;,tall,splits,stack";
      scrollback_lines = 1000000;
      enable_audio_bell = false;
      update_check_interval = 0;
      wheel_scroll_multiplier = 1;
      wheel_scroll_min_lines = 1;
      touch_scroll_multiplier = 1;
      confirm_os_window_close = 0;
      shell_integration = "enabled";
      scrollback_pager = ''nvim -c "set nonumber nolist showtabline=0 foldcolumn=0 laststatus=0 noshowmode noruler noshowcmd ignorecase smartcase incsearch shortmess+=F" -c "autocmd TermOpen * normal G" -c "map q :qa!<CR>" -c "set clipboard+=unnamedplus" -c "silent write! /tmp/kitty_scrollback_buffer | te echo -n \"$(cat /tmp/kitty_scrollback_buffer)\" && sleep 1000"'';
      macos_option_as_alt = true;
      tab_bar_min_tabs = 1;
      tab_title_template = "{title}";
      active_tab_title_template = "{title} - {num_windows} {layout_name}";
      tab_bar_edge = "top";
      tab_bar_style = "slant";
      tab_bar_align = "center";
      tab_activity_symbol = "◉";
      # enable nerdfont icons
      symbol_map = "U+23FB-U+23FE,U+2B58,U+E200-U+E2A9,U+E0A0-U+E0A3,U+E0B0-U+E0BF,U+E0C0-U+E0C8,U+E0CC-U+E0CF,U+E0D0-U+E0D2,U+E0D4,U+E700-U+E7C5,U+F000-U+F2E0,U+2665,U+26A1,U+F400-U+F4A8,U+F67C,U+E000-U+E00A,U+F300-U+F313,U+E5FA-U+E62B JetBrainsMono Nerd Font";
    };
    font = {
      size = if isDarwin then 16 else 12; # physically equivalent
      name = "JetBrains Mono";
    };
    keybindings = {
      "kitty_mod+n" = "new_window_with_cwd";
      "alt+enter" = "new_window_with_cwd";
      "alt+j" = "next_window";
      "alt+k" = "previous_window";
      "alt+shift+j" = "move_window_forward";
      "alt+shift+k" = "move_window_backward";
      "alt+r" = "start_resizing_window";
      "alt+o" = "toggle_layout stack"; # temporarily maximize a window
      "alt+p" = "next_layout";
      "alt+w" = "close_window";
      "alt+shift+p" = "last_used_layout";
      "alt+shift+r" = "set_tab_title";
      "alt+." = "layout_action bias 50 62 70 80";
    } // (if isDarwin then {
    } else {
      "super+shift+enter" = "new_os_window_with_cwd";
      "alt+t" = "new_tab";
      "alt+]" = "next_tab";
      "alt+[" = "previous_tab";
    });
    theme = if theme == "dark" then "Ayu Mirage" else "Rosé Pine Dawn";
  };
}