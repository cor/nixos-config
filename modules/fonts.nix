{ pkgs-unstable, ... }:
{
  fonts.packages = with pkgs-unstable; [
    font-awesome
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    ibm-plex
    fira-code
    fira-code-symbols
    nerd-fonts.jetbrains-mono
  ];
}
