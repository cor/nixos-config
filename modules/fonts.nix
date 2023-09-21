{ pkgs-unstable, ... }:
{
  fonts.fonts = with pkgs-unstable; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    ibm-plex
    fira-code
    fira-code-symbols
    jetbrains-mono
    (pkgs-unstable.nerdfonts.override {
      fonts = [ "JetBrainsMono" ];
    })
  ];
}
