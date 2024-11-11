{ inputs, pkgs, config, theme, isDarwin, ... }:
{
  # start the emacs daemon
  services.emacs = 
  let
    # Define a wrapped version of Emacs with the environment variable set
    # to fix the SSH_AUTH_SOCK issue. See home-modules/zsh.nix line 37
    emacsWithEnv = pkgs.writeShellScriptBin "emacs" ''
      #!/bin/sh
      export SSH_AUTH_SOCK=/home/cor/.ssh/ssh_auth_sock
      exec ${config.programs.emacs.finalPackage}/bin/emacs "$@"
    '';
  in
  {
    enable = true;
    package = emacsWithEnv;
  };

  # the emacs package that will be used by the emacs daemon
  programs.emacs = {
    enable = true;
    package = inputs.emacs-overlay.packages.${pkgs.system}.emacs-unstable;
    extraPackages = epkgs: [ epkgs.vterm ];
  };
}
