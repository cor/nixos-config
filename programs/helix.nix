package: {
    enable = true;
    inherit package;

    settings = {
      theme = "gruvbox_dark_hard";
      editor = {
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
      };
    };

    languages = [
      {
        name = "rust";
        config = {
          checkOnSave.command = "clippy";
          cargo.allFeatures = true;
          procMacro.enable = true;
        };
      }
    ];
  }

