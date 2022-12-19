package: {
  enable = true;
  inherit package;

  settings = {
    theme = "gruvbox_dark_hard";
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

