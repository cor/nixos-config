package: {
  enable = true;
  inherit package;

  settings = {
    theme = "gruvbox_patched";
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
      lsp.display-messages = true;
      bufferline = "always";
      statusline = {
        left = [ "mode" "spinner" "file-name" ];
        right = [ "diagnostics" "position" "total-line-numbers" "file-encoding" ];
      };
    };
  };

  # patch until https://github.com/helix-editor/helix/pull/5066 gets merged
  themes = {
    gruvbox_patched = {
      inherits = "gruvbox_dark_hard";

      "diagnostic.error" = { 
        underline = { style = "curl"; color = "red0"; };
      };

      "diagnostic.warning" = { 
        underline = { style = "curl"; color = "orange1"; };
      };

      "diagnostic.info" = { 
        underline = { style = "curl"; color = "aqua1"; };
      };

      "diagnostic.hint" = { 
        underline = { style = "curl"; color = "blue1"; };
      };
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
      name = "nix";
      config = {
        auto-format = true;
      };
    }
  ];
}

