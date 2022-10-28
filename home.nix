inputs: { config, lib, pkgs, ... }:
let
  discord-chromium = pkgs.makeDesktopItem rec {
    name = "Discord";
    desktopName = "Discord";
    genericName = "All-in-one cross-platform voice and text chat for gamers";
    exec = "${pkgs.chromium}/bin/chromium --app=\"https://discord.com/channels/@me\"";
    icon = "discord";
    type = "Application";
    terminal = false;
  };
  slack-chromium = pkgs.makeDesktopItem rec {
    name = "Slack";
    desktopName = "Slack";
    genericName = "One platform for your team and your work";
    exec = "${pkgs.chromium}/bin/chromium --app=\"https://app.slack.com/client/T021F0XJ8BE/C02MSA16DCP\"";
    icon = "slack";
    type = "Application";
    terminal = false;
  };
  whatsapp-chromium = pkgs.makeDesktopItem rec {
    name = "WhatsApp";
    desktopName = "WhatsApp";
    genericName = "Chat app built by Meta";
    exec = "${pkgs.chromium}/bin/chromium --app=\"https://web.whatsapp.com\"";
    icon = "whatsapp";
    type = "Application";
    terminal = false;
  };
  clickup-chromium = pkgs.makeDesktopItem rec {
    name = "ClickUp";
    desktopName = "ClickUp";
    genericName = "One app to replace them all";
    exec = "${pkgs.chromium}/bin/chromium --app=\"https://app.clickup.com/\"";
    icon = "clickup";
    type = "Application";
    terminal = false;
  };
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.system; config.allowUnfree = true; };
in
{
  xdg.enable = true;

  home.packages = with pkgs; [
    bat # cat replacement
    exa # ls replacement
    gping # ping with graph
    fd
    thunderbird
    fzf
    htop
    jq
    ripgrep
    ranger
    tree
    watch
    kitty
    openssh
    zip
    rnix-lsp
    curl
    delta
    pamixer
    wget
    git
    scrot
    git-lfs
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
    vscode
    bottom
    discord-chromium
    tdesktop
    lazygit
    element-desktop
    slack-chromium
    whatsapp-chromium
    clickup-chromium
    (writeShellScriptBin "xset-r-fast" ''
      xset r rate 150 40
    '')
    (writeShellScriptBin "xset-r-slow" ''
      xset r rate 250 30
    '')
  ] ++ 
    [
    pkgs-unstable.flameshot
    pkgs-unstable._1password-gui
    pkgs-unstable.obsidian
  ];

  home.file."Screenshots/.keep".source = ./.keep;
  home.file.".config/awesome".source = ./awesome;
  home.file.".config/ranger/rc.conf".source = ./ranger.conf;

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

  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    secureSocket = false;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 1000000;
    baseIndex = 1;
    plugins = with pkgs.tmuxPlugins; [ pain-control ];
    extraConfig = ''
      set -g mouse on
    '';
  };

  programs.git = {
    enable = true;
    userName = "cor";
    userEmail = "cor@pruijs.dev";
    lfs.enable = true;
    signing = {
      signByDefault = true;
      key = "06A6337C2BDD1365883C0668DB347466107E589F";
    };
    extraConfig = {
      color.ui = true;
      github.user = "cor";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      scrolling = {
        history = 100000;
        multiplier = 1;
        faux_multiplier = 1;
        auto_scroll = false;
      };
    };
  };

  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.default;

    settings = {
      theme = "catppuccin_macchiato";
      editor = {
        completion-trigger-len = 0;
        scroll-lines = 1;
        scrolloff = 5;
        cursorline = true;
        color-modes = true;
        indent-guides.render = true;
        file-picker.hidden = false;
        auto-pairs = false;
        lsp.display-messages = true;
        bufferline = "always";
      };
    };

    languages = [
      {
        name = "rust";
        config = {
          checkOnSave.command = "clippy";
          cargo.allFeatures = true;
          procMacro.enable = true;
        };
      }
    ];
  };

  programs.chromium = {
    enable = true;
    package = pkgs.chromium;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
      "fihnjjcciajhdojfnbdddfaoknhalnja" # I don't care about cookies
      "gcbommkclmclpchllfjekcdonpmejbdp" # Https everywhere
      "bkdgflcldnnnapblkhphbgpggdiikppg" # DuckDuckGo
      "ennpfpdlaclocpomkiablnmbppdnlhoh" # Rust Search Extension
      "mjdepdfccjgcndkmemponafgioodelna" # DF Tube (Distraction Free for YouTube)
      "dneaehbmnbhcippjikoajpoabadpodje" # Old reddit redirect
      "ililagkodjpoopfjphagpamfhfbamppa" # Less distracting reddit
      "blaaajhemilngeeffpbfkdjjoefldkok" # LeechBlock
      "mopnmbcafieddcagagdcbnhejhlodfdd" # Polkadot js
      "aeblfdkhhhdcdjpifhhbdiojplfjncoa" # 1Password
    ];
  };

  programs.zsh = {
    enable = true;
    prezto = {
      enable = true;
      pmodules = [
        "git"
        "environment"
        "terminal"
        "editor"
        "history"
        "directory"
        "spectrum"
        "utility"
        "completion"
        "syntax-highlighting"
        "history-substring-search"
        "prompt"
      ];
    };
    shellAliases = {
      fzf-nix = "nix-env -qa | fzf";
      icat = "kitty +kitten icat";
      lg = "lazygit";
      pbcopy = "xclip -selection c"; # macOS' pbcopy equivalent
      ls = "exa";
    };
    initExtra = ''
      if [ -n "''${commands[fzf-share]}" ]; then
        source "''$(fzf-share)/key-bindings.zsh"
        source "''$(fzf-share)/completion.zsh"
      fi
      compinit
    ''; # compinit is required for zsh autocomplete
  };

  programs.gpg = {
    enable = true;
    settings = {
      default-key = "06A6337C2BDD1365883C0668DB347466107E589F";
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      scrollback_lines = 1000000;
      enable_audio_bell = false;
      update_check_interval = 0;
      wheel_scroll_multiplier = 1;
      wheel_scroll_min_lines = 1;
      touch_scroll_multiplier = 1;
    };
    keybindings = {
      "kitty_mod+n" = "new_os_window_with_cwd";
    };
    theme = "One Half";
  };
  
  xsession.windowManager.awesome.enable = true;
  
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
    enableSshSupport = true;

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };
  xresources.properties = {
    "Xft.dpi" = 192;
  };
  
  services.flameshot = {
    enable = true;
    package = pkgs-unstable.flameshot;
    settings = {
      General = {
        savePath="/home/cor/Screenshots";
        showStartupLaunchMessage = false;
        disabledTrayIcon = true;
        filenamePattern = "%F-%H%M%S";
        startupLaunch = true;
        saveAfterCopy = true;
      };
    };
  };
  
}
