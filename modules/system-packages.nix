{ inputs, machine, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    tree
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
    ripgrep
    fd
    emacsPackages.vterm
    libvterm
  ] ++ [
    inputs.ghostty.packages.${machine.system}.ghostty
  ];
}
