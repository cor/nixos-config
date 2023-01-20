{
    enable = true;
    prezto = {
      enable = true;
      pmodules = [
        "git"
        "environment"
        "terminal"
        "editor"
        "history"
        "directory"
        "spectrum"
        "utility"
        "completion"
        "syntax-highlighting"
        "history-substring-search"
        "prompt"
      ];
    };
    shellAliases = {
      fzf-nix = "nix-env -qa | fzf";
      icat = "kitty +kitten icat";
      lg = "lazygit";
      pbcopy = "xclip -selection c"; # macOS' pbcopy equivalent
      ls = "exa";
      hxc = "CARGO_TARGET_DIR=target/rust-analyzer /etc/profiles/per-user/cor/bin/hx"; # speed increase for rust-analyzer
      nd = "nix develop --command zsh";
      cco = "cd /home/cor/dev/composable && nd";
      ccoh = "cd /home/cor/dev/composable && nd && hxc";
    };
    initExtra = ''
      if [ -n "''${commands[fzf-share]}" ]; then
        source "''$(fzf-share)/key-bindings.zsh"
        source "''$(fzf-share)/completion.zsh"
      fi
      compinit
    ''; # compinit is required for zsh autocomplete
  }

