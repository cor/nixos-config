{ inputs, pkgs, theme, ... }:
{
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.default;

    settings = {
      theme = if theme == "dark" then "gruvbox_dark_soft" else "rose_pine_dawn";
      editor = {
        auto-format = true;
        completion-trigger-len = 0;
        scroll-lines = 1;
        scrolloff = 5;
        cursorline = false;
        color-modes = true;
        indent-guides.render = true;
        file-picker.hidden = false;
        auto-pairs = false;
        inline-diagnostics = {
          cursor-line = "hint";
        };
        lsp = {
          enable = true;
          display-messages = true;
          display-progress-messages = true;
          display-inlay-hints = true;
        };
        bufferline = "always";
        statusline = {
          left = [ "mode" "spinner" "file-name" ];
          right = [ "diagnostics" "position" "total-line-numbers" "file-encoding" ];
          center = [ "version-control" ];
        };
        soft-wrap = {
          enable = true;
        };
      };

      keys.normal.space = {
        "h" = ":toggle-option lsp.display-inlay-hints";
        "c" = [ ":write-all" ];
        # f and F are swapped, as picking in cwd is much more common for me.
        "f" = "file_picker_in_current_directory";
        "F" = "file_picker";
        "e" = "file_explorer_in_current_buffer_directory";
        "E" = "file_explorer";
      };
      keys.normal.space."0" = {
        "8" = [ ":rla" ":lsp-restart" ];
        "9" = [
          ":sh zellij action focus-next-pane"
          ":sh sleep 0.2 && zellij action write-chars \"/read %{buffer_name}\""
        ];
        "0" = [
          ":sh zellij action focus-next-pane"
          ":sh sleep 0.2 && zellij action write-chars \"/add %{buffer_name}\""
        ];
      };
      keys.normal.space."4" = {
        "b" = ":sh git blame %{buffer_name}";
        "y" = ":pipe-to gh-permalink %{buffer_name} %{cursor_line} | pbcopy";
      };
      keys.select.space."4" = {
        "y" = ":pipe-to gh-permalink %{buffer_name} %{cursor_line} | pbcopy";
      };
    };

    themes = {
      transparent_catppuccin_frappe = {
        inherits = "catppuccin_frappe";
        "ui.background" = {
          fg = "foreground";
        };
      };
    };

    languages = {
      language = [
        {
          name = "svelte";
          formatter = { command = "prettier"; args = [ "--parser" "svelte" ]; };
          auto-format = true;
        }
        {
          name = "typescript";
          formatter = { command = "prettier"; args = [ "--parser" "typescript" ]; };
          auto-format = true;
        }
        {
          name = "json";
          formatter = { command = "prettier"; args = [ "--parser" "json" ]; };
          auto-format = true;
        }
        {
          name = "nix";
          formatter = { command = "nixpkgs-fmt"; };
          auto-format = true;
          language-servers = [ "nil" ];
          # language-servers = [ "nixd" "nil" ];
        }
        {
          name = "xml";
          formatter = {
            command = "xmllint";
            auto-format = true;
            args = [ "--format" "-" ];
          };
        }
      ];

      language-server = {
        # nixd = {
        #   command = "nixd";
        # };
        rust-analyzer = {
          config = {
            checkOnSave.command = "clippy";
            # Careful! If you enable this, then a lot of errors
            # will no longer show up in Helix. Do not enable it.
            # cargo.allFeatures = true; <- do NOT enable me
          };
        };
      };
    };
  };
}

