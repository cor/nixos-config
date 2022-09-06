inputs: {config, lib, pkgs, ... }:
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
  clickup-chromium = pkgs.makeDesktopItem rec {
    name = "ClickUp";
    desktopName = "ClickUp";
    genericName = "One app to replace them all";
    exec = "${pkgs.chromium}/bin/chromium --app=\"https://app.clickup.com/\"";
    icon = "clickup";
    type = "Application";
    terminal = false;
  };
in
{
  xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.
  home.packages = with pkgs; [
    bat # cat replacement
    exa # ls replacement
    gping # ping with graph
    fd
    firefox
    fzf
    htop
    jq
    ripgrep
    ranger
    tree
    watch
    kitty
    openssh
    feh
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
    clickup-chromium
    (writeShellScriptBin "feh-bg-fill" ''
      feh --bg-fill /home/cor/.background-image
    '')
  ];


  home.file.".background-image".source = ../../wallpapers/nix-space.jpg;
  home.file."Screenshots/.keep".source = ./.keep;
  # home.file.".config/helix/config.toml".source = ./helix.toml;
  # home.file.".config/helix/languages.toml".source = ./languages.toml;

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  # home.sessionVariables = {
  #   LANG = "en_US.UTF-8";
  #   LC_CTYPE = "en_US.UTF-8";
  #   LC_ALL = "en_US.UTF-8";
  #   EDITOR = "nvim";
  #   PAGER = "less -FirSwX";
  #   MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
  # };

  # home.file.".gdbinit".source = ./gdbinit;
  # home.file.".inputrc".source = ./inputrc;

  # xdg.configFile."i3/config".text = builtins.readFile ./i3;
  xdg.configFile."rofi/config.rasi".text = builtins.readFile ./rofi;
  # xdg.configFile."devtty/config".text = builtins.readFile ./devtty;

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  # programs.bash = {
  #   enable = true;
  #   shellOptions = [];
  #   historyControl = [ "ignoredups" "ignorespace" ];
  #   # initExtra = builtins.readFile ./bashrc;
  # };

  # programs.direnv = {
  #   enable = true;

    # config = {
    #   whitelist = {
    #     prefix= [
    #       "$HOME/code/go/src/github.com/hashicorp"
    #       "$HOME/code/go/src/github.com/mitchellh"
    #     ];

    #     exact = ["$HOME/.envrc"];
    #   };
    # };
  # };

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
      # branch.autosetuprebase = "always";
      color.ui = true;
      # core.askPass = ""; # needs to be empty to use terminal for ask pass
      # credential.helper = "store"; # want to make this more secure
      github.user = "cor";
      # push.default = "tracking";
      # init.defaultBranch = "main";
    };
  };
  
  programs.helix = {
      enable = true;
      package = inputs.helix.packages.${pkgs.system}.default;       
      
      settings = {
        theme = "catppuccin_macchiato";
        editor = {
          line-number = "relative";
          completion-trigger-len = 0;
          scroll-lines = 1;
          scrolloff = 5;
          cursorline = true;
          color-modes = true;
          indent-guides.render = true;
          file-picker.hidden = false;
          auto-pairs = false;
          lsp.display-messages = true;
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
    '';
  };

  programs.gpg = {
    enable = true;
    settings = {
      default-key = "06A6337C2BDD1365883C0668DB347466107E589F";
    };
  };

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.kitty}/bin/kitty";
    theme = ./rofi;
    plugins = [ pkgs.rofi-emoji ];
  };

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty.conf;
  };


  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
    enableSshSupport = true;

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      mpdSupport = true;
      pulseSupport = true;
    };
    config = ./polybar.ini;
    script = ''
      polybar main &
    '';
  };


  xresources.extraConfig = builtins.readFile ./Xresources;

  # Make cursor not tiny on HiDPI screens
  home.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };
}
