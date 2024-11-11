{ inputs, pkgs, theme, isDarwin, ... }:
{
  programs.emacs = {
    enable = true;
    package = inputs.emacs-overlay.packages.${pkgs.system}.emacs-unstable;
    extraPackages = epkgs: [ epkgs.vterm ];
  };
}
