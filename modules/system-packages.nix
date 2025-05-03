{ inputs, machine, pkgs, pkgs-unstable, ... }:
{
  environment.systemPackages =

    let
      common = with pkgs; [
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
        wakeonlan
        nix-output-monitor
      ]
      ++ (with pkgs-unstable; [
        aider-chat
      ])
      ++ [
        inputs.open-project.packages.${machine.system}.default
        inputs.gh-permalink.packages.${machine.system}.default
      ] ++ (pkgs.lib.optionals (machine.name != "raspberry-pi") [
        inputs.ghostty.packages.${machine.system}.ghostty
      ]);
      gui = with pkgs-unstable; [
        _1password-gui
        brave
        signal-desktop
      ];
    in
    if machine.headless then common else common ++ gui;
}
