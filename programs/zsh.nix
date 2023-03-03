{
    enable = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;    
    shellAliases = {
      fzf-nix = "nix-env -qa | fzf";
      icat = "kitty +kitten icat";
      lg = "lazygit";
      pbcopy = "xclip -selection c"; # macOS' pbcopy equivalent
      ls = "exa";
      hxc = "CARGO_TARGET_DIR=target/rust-analyzer /etc/profiles/per-user/cor/bin/hx"; # speed increase for rust-analyzer
      nd = "nix develop --command zsh";
      gs = "git status";
    };
  }

