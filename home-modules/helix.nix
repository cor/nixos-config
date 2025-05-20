{ inputs, pkgs, config, ... }:
{
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.default;

    settings = {
      theme = if config.stylix.polarity == "dark" then "penumbra+" else "yo_light";
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

      keys.normal = {
        space = {
          "h" = ":toggle-option lsp.display-inlay-hints";
          "c" = [ ":write-all" ];
          # f and F are swapped, as picking in cwd is much more common for me.
          "f" = "file_picker_in_current_directory";
          "F" = "file_picker";
          # https://github.com/sxyazi/yazi/pull/2461#issuecomment-2849445737
          "e" = [
            '':sh rm -f /tmp/unique-file''
            '':insert-output yazi "%{buffer_name}" --chooser-file=/tmp/unique-file''
            '':insert-output echo "\x1b[?1049h\x1b[?2004h" > /dev/tty''
            '':open %sh{cat /tmp/unique-file}''
            '':redraw''
            # https://github.com/helix-editor/helix/wiki/Recipes#advanced-file-explorer-with-yazi
            '':set mouse false''
            '':set mouse true''
          ];
          "E" = "file_explorer";
        };
        ret = "goto_word";
      };
      keys.normal.space."0" = {
        "8" = [ ":rla" ":lsp-restart" ];
        "9" = [
          ":sh zellij action focus-next-pane"
          ":sh sleep 0.1 && zellij action write-chars \"/read %{buffer_name}\""
          ":sh sleep 0.4 && zellij action write 9"
          ":sh sleep 0.5 && zellij action write 13"
        ];
        "0" = [
          ":sh zellij action focus-next-pane"
          ":sh sleep 0.1 && zellij action write-chars \"/add %{buffer_name}\""
          ":sh sleep 0.4 && zellij action write 9"
          ":sh sleep 0.5 && zellij action write 13"
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

