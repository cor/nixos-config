{ machine, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history = {
      save = 10000000;
      size = 10000000;
    };
    shellAliases = {
      fzf-nix = "nix-env -qa | fzf";
      lg = "lazygit";
      pbcopyy = "xclip -selection c"; # macOS' pbcopy equivalent
      hxc = "CARGO_TARGET_DIR=target/rust-analyzer /etc/profiles/per-user/cor/bin/hx"; # speed increase for rust-analyzer
      hxt = "CARGO_TARGET_DIR=target/rust-analyzer nix run github:pinelang/helix-tree-explorer/tree_explore"; # Helix PR with tree explorer
      nd = "nix develop --command zsh";
      gs = "git status";
      update-time = "sudo date -s \"$(wget -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | cut -d' ' -f5-8)Z\"";
      nixbuild-shell = "ssh eu.nixbuild.net shell";
      s = "kitty +kitten ssh -A";
    };
    initContent =
      let
        darwinInit = ''
          # Check if SSH_AUTH_SOCK is set and points to the default macOS agent
          if [[ -z "$SSH_AUTH_SOCK" || "$SSH_AUTH_SOCK" == /private/tmp/com.apple.launchd.* ]]; then
            # No forwarded agent, use 1Password agent
            export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
          fi
        '';
        linuxInit = ''
          # set the symlink that code-server/emacs uses to the most recently logged in $SSH_AUTH_SOCK
          # if [ ! -h "$SSH_AUTH_SOCK" ]; then 
          #   ln -sfv "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock; 
          # fi
        '';
        sharedInit = ''
          # Edit command line widget
          edit-command-line() {
            local tmpfile="$(mktemp)"
            echo "$BUFFER" > "$tmpfile"
            ${"$"}EDITOR "$tmpfile"
            BUFFER="$(<$tmpfile)"
            rm -f "$tmpfile"
            zle redisplay
          }
          zle -N edit-command-line
          bindkey '\ee' edit-command-line
        '';
      in
      if machine.darwin then
        darwinInit + sharedInit
      else
        linuxInit + sharedInit;
  };
}

