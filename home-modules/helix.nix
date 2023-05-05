{ inputs, pkgs, theme, ...}: 
{
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.default;

    settings = {
      theme = if theme == "dark" then "ayu_mirage" else "rose_pine_dawn";
      editor = {
        auto-format = true;
        completion-trigger-len = 0;
        scroll-lines = 1;
        scrolloff = 5;
        cursorline = true;
        color-modes = true;
        indent-guides.render = true;
        file-picker.hidden = false;
        auto-pairs = false;
        lsp = {
          enable = true;
          display-messages = true;
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
        "c" = [":write-all"];
      };
    };
 
    languages = [
      {
        name = "rust";
        config = {
          checkOnSave.command = "clippy";
          # Careful! If you enable this, then a lot of errors
          # will no longer show up in Helix. Do not enable it.
          # cargo.allFeatures = true; <- do NOT enable me

        };
      }
      {
        name = "svelte";
        formatter = { command = "prettier"; args = ["--parser" "svelte"]; };
        auto-format = true;
      }
      {
        name = "typescript";
        formatter = { command = "prettier"; args = ["--parser" "typescript"]; };
        auto-format = true;
      }
      {
        name = "json";
        formatter = { command = "prettier"; args = ["--parser" "json"]; };
        auto-format = true;
      }
      {
        name = "nix";
        formatter = { command = "nixpkgs-fmt"; };
        auto-format = true;
      }
    ];
  };
}

