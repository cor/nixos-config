{ isDarwin, ...}:
{
  programs.zsh = { 
    enable = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;    
    shellAliases = {
      fzf-nix = "nix-env -qa | fzf";
      icat = "kitty +kitten icat";
      lg = "lazygit";
      pbcopyy = "xclip -selection c"; # macOS' pbcopy equivalent
      ls = "exa";
      hxc = "CARGO_TARGET_DIR=target/rust-analyzer /etc/profiles/per-user/cor/bin/hx"; # speed increase for rust-analyzer
      hxt = "CARGO_TARGET_DIR=target/rust-analyzer nix run github:pinelang/helix-tree-explorer/tree_explore"; # Helix PR with tree explorer
      nd = "nix develop --command zsh";
      gs = "git status";
      update-time = "sudo date -s \"$(wget -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | cut -d' ' -f5-8)Z\"";
    } // (if isDarwin then {} else {
      open = "xdg-open";
    });
  };
}

