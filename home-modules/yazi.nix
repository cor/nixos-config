{ inputs, pkgs, theme, isDarwin, ... }:
{
  programs.yazi = {
    enable = true;
    package = if isDarwin then pkgs.yazi else inputs.yazi.packages.${pkgs.system}.default;
    enableZshIntegration = true;
  };
}

