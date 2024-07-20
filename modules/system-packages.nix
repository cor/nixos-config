{ ghostty, to-case, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    tree
    helix
    curl
    zsh
    fzf
    wget
    zellij
    gnumake
    git
    gh
    bottom
    neofetch
    libxml2
  ] ++ [ ghostty to-case ];
}
