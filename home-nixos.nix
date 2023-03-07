inputs: { config, lib, pkgs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.system; config.allowUnfree = true; };
  dark-ungoogled-chromium = pkgs-unstable.ungoogled-chromium.override { commandLineArgs = "--force-dark-mode --enable-features=WebUIDarkMode"; };
  mkChromiumApp = import ./lib/mk-chromium-app.nix { inherit pkgs; chromium = dark-ungoogled-chromium; };
in
{
  xdg.enable = true;
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    bat # cat replacement
    exa # ls replacement
    gping # ping with graph
    gh
    fd
    thunderbird
    fzf
    htop
    jq
    ripgrep
    ranger
    tree
    watch
    openssh
    zip
    rnix-lsp
    curl
    delta
    pamixer
    wget
    scrot
    coreutils-full
    binutils
    gnome3.gnome-control-center
    xclip
    gtkmm3 # needed for the vmware user tools clipboard
    neofetch
    nixfmt
    pinentry
    pinentry-curses
    pick-colour-picker
    bottom
    (writeShellScriptBin "xset-r-fast" ''
      xset r rate 150 40
    '')
    (writeShellScriptBin "xset-r-slow" ''
      xset r rate 250 30
    '')
  ] ++
  (with pkgs-unstable; [
    zellij
    vscode
    flameshot
    _1password-gui
    obsidian
    tdesktop
    element-desktop
  ]) ++
  map mkChromiumApp [
    {
      name = "Discord";
      genericName = "All-in-one cross-platform voice and text chat for gamers";
      url = "https://discord.com/channels/@me";
    }
    {
      name = "Slack";
      genericName = "One platform for your team and your work";
      url = "https://app.slack.com/client/T021F0XJ8BE/C02MSA16DCP";
    }
    {
      name = "WhatsApp";
      genericName = "Chat app built by Meta";
      url = "https://web.whatsapp.com";
    }
    {
      name = "ClickUp";
      genericName = "One app to replace them all";
      url = "https://app.clickup.com/";
    }
  ];

  # Ensure that the `Screenshots/` directory exists
  home.file."Screenshots/.keep".text = "";
  home.file.".config/awesome".source = ./awesome;

  # Configure ranger to user kitty's image preview
  home.file.".config/ranger/rc.conf".text = ''
    set preview_images true
    set preview_images_method kitty
  '';

  gtk = {
    enable = true;

    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };

    iconTheme = {
      package = pkgs.paper-icon-theme;
      name = "Paper";
    };
  };

  programs.tmux = import programs/tmux.nix;
  programs.git = import programs/git.nix;
  programs.gpg = import programs/gpg.nix;
  programs.zsh = import programs/zsh.nix;
  programs.kitty = import programs/kitty.nix { isDarwin = false; package = pkgs-unstable.kitty; };
  programs.helix = import programs/helix.nix inputs.helix.packages.${pkgs.system}.default;
  programs.rofi = import programs/rofi.nix pkgs;
  programs.chromium = import programs/chromium.nix { package = dark-ungoogled-chromium; inherit lib; };
  programs.lazygit = import programs/lazygit.nix pkgs-unstable.lazygit; 
  xsession.windowManager.awesome.enable = true;

  services.flameshot = import services/flameshot.nix pkgs-unstable.flameshot;
  services.gpg-agent = import services/gpg-agent.nix;

  xresources.properties = let dpi = 192; in {
    "Xft.dpi" = dpi;
    "*.dpi" = dpi;
  };

}
