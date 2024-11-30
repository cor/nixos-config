{ machine, ... }:
{
  programs.zsh = {
    enable = true; # default shell on catalina

    promptInit = ''
      if [ -n "''${commands[fzf-share]}" ]; then
        source "''$(fzf-share)/key-bindings.zsh"
        source "''$(fzf-share)/completion.zsh"
      fi

    ''
    +
    (if machine.darwin then "" else ''compinit'');
  };
}
