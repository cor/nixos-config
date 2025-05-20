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
        claude-code
      ])
      ++ (with inputs.self.packages.${machine.system}; [
        dark-mode
        light-mode
      ])
      ++ [
        inputs.open-project.packages.${machine.system}.default
        inputs.gh-permalink.packages.${machine.system}.default
      ] ++ (pkgs.lib.optionals (machine.name != "raspberry-pi") [
        inputs.ghostty.packages.${machine.system}.ghostty
      ]);
      gui = (with pkgs; [
        wl-clipboard
        wayland-utils
        libsecret
        brave
        signal-desktop
        element-desktop
        telegram-desktop
        fuzzel
        xwayland-satellite
        guvcview
        easyeffects
        pavucontrol
        nvtopPackages.amd
        brightnessctl
        playerctl
        blanket
        dig

        # Enable iOS USB connection
        libimobiledevice

        # screenshotting, see niri keybind
        (pkgs.writeShellApplication {
          name = "cor-screenshot";
          runtimeInputs = [
            grim
            satty
            slurp
          ];
          text = ''
            grim -g "$(slurp -c '#ff0000ff')" -t ppm - | satty --filename - --fullscreen --output-filename "$HOME/Pictures/Screenshots/screenshot-$(date '+%Y-%m-%dT%H:%M:%S').png" --save-after-copy --copy-command wl-copy --early-exit 
          '';
        })

      ]) ++ (with pkgs-unstable; [
        # jetbrains.datagrip
        _1password-gui
        obsidian
      ]);
    in
    if machine.headless then common else common ++ gui;
}
