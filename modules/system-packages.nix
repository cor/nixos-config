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
    # emacsPackages.vterm
    # libvterm
    wakeonlan
    nix-output-monitor
  ] ++ [
    inputs.open-project.packages.${machine.system}.default
    inputs.gh-permalink.packages.${machine.system}.default
  ] ++ (pkgs.lib.optionals (machine.name != "raspberry-pi") [
    inputs.ghostty.packages.${machine.system}.ghostty
  ]);
}
