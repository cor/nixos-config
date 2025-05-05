{ pkgs-unstable, ... }:
{
  fonts.packages = with pkgs-unstable; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    ibm-plex
    fira-code
    fira-code-symbols
    nerd-fonts.jetbrains-mono
  ];
}
