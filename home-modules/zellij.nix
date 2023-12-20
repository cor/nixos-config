{ pkgs-unstable, ... }:
{
  programs.zellij = {
    enable = true;
    package = pkgs-unstable.zellij;
  };

  # Nix does not translate nicely to KDL so we use a KDL file instead.
  home.file.".config/zellij/config.kdl".source = ./zellij-config.kdl;

  # Needed to let Zellij find SSH_AUTH_SOCK after re-attaching to session
  # cfr: https://github.com/zellij-org/zellij/issues/862#issuecomment-973881560
  # ---------------------------------------------------
  # programs.zsh.initExtra = (if isDarwin then "" else ''
  #   export SSH_AUTH_SOCK="$HOME/.ssh/ssh_auth_sock"
  # '');

  # home.file.".ssh/rc".text = ''
  #   if test "$SSH_AUTH_SOCK"; then
  #     ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
  #   fi
  # '';
  # ---------------------------------------------------
}
