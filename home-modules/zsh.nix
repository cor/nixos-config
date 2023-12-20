{ isDarwin, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      fzf-nix = "nix-env -qa | fzf";
      icat = "kitty +kitten icat";
      lg = "lazygit";
      pbcopyy = "xclip -selection c"; # macOS' pbcopy equivalent
      hxc = "CARGO_TARGET_DIR=target/rust-analyzer /etc/profiles/per-user/cor/bin/hx"; # speed increase for rust-analyzer
      hxt = "CARGO_TARGET_DIR=target/rust-analyzer nix run github:pinelang/helix-tree-explorer/tree_explore"; # Helix PR with tree explorer
      nd = "nix develop --command zsh";
      gs = "git status";
      update-time = "sudo date -s \"$(wget -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | cut -d' ' -f5-8)Z\"";
      nixbuild-shell = "ssh eu.nixbuild.net shell";
      s = "kitty +kitten ssh -A";
    } // (if isDarwin then {
      snos = "kitty +kitten ssh -A -p 2200 localhost";
    } else {
      open = "xdg-open";
    });
  };
}

