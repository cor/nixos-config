inputs: { config, lib, pkgs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.system; config.allowUnfree = true; };
  dark-ungoogled-chromium = pkgs-unstable.ungoogled-chromium.override { commandLineArgs = "--force-dark-mode --enable-features=WebUIDarkMode"; };
  mkChromiumApp = import ./lib/mk-chromium-app.nix { inherit pkgs; chromium = dark-ungoogled-chromium; };
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
    tdesktop
    lazygit
    element-desktop
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
  ] ++
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
    # enable = true;
    settings = {
      scrolling = {
        history = 100000;
        multiplier = 1;
        faux_multiplier = 1;
        auto_scroll = false;
      };
    };
  };

  programs.helix = import programs/helix.nix inputs.helix.packages.${pkgs.system}.default;

  programs.chromium = {
    enable = true;
    package = dark-ungoogled-chromium;

    extensions =
        let
          createChromiumExtensionFor = browserVersion: { id, sha256, version }:
            {
              inherit id;
              crxPath = builtins.fetchurl {
                url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
                name = "${id}.crx";
                inherit sha256;
              };
              inherit version;
            };
          createChromiumExtension = createChromiumExtensionFor (lib.versions.major dark-ungoogled-chromium.version);
        in
        [
          (createChromiumExtension {
            # ublock origin
            id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
            sha256 = "sha256:0pv1bn42b4i2nnlpw88v8sdpj8y87zh16zic0p4pwh18chh10z5n";
            version = "1.44.4";
          })
          (createChromiumExtension {
            # vimium
            id = "dbepggeogbaibhgnhhndojpepiihcmeb";
            sha256 = "sha256:0sj5najixk40r1hjf9kzq2jns6klfsmipwdj8jl5z76chx9pi3hs";
            version = "1.67.2";
          })
          (createChromiumExtension {
            # 1password
            id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";
            sha256 = "sha256:0ccvpi88s3c1psb5ipkz4cch89ib6h3g9nw8qbxzwvnzh72qg8rl";
            version = "2.4.1";
          })
          (createChromiumExtension {
            # Empty new tab
            id = "dpjamkmjmigaoobjbekmfgabipmfilij";
            sha256 = "sha256:1fv65lfrh1jh9rz3wq26ri4hzkv9n4j563v1arzwys1f8g015fks";
            version = "1.2.0";
          })
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
      confirm_os_window_close = 0;
      shell_integration = "enabled";
    };
    keybindings = {
      "kitty_mod+n" = "new_os_window_with_cwd";
    };
    theme = "Gruvbox Dark Hard";
  };

  xsession.windowManager.awesome.enable = true;

  services.picom = {
    enable = true;

    extraOptions = ''
      shadow = true;
      corner-radius = 18

      shadow-radius = 50
      shadow-offset-x = 1
      shadow-offset-y = 9
      shadow-opacity = 0.2
      
      # blur is disabled because it makes my VM very slow :(

      # blur-background = true
      # blur-method = "kernel"
      # blur-kern = "31,31,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1";


      # Exclude conditions for rounded corners.
      rounded-corners-exclude = [
        "window_type = 'dock'",
        "window_type = 'desktop'",
        "window_type = '_NET_WM_WINDOW_TYPE_POPUP_MENU'"
      ];
    '';
  };

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
        savePath = "/home/cor/Screenshots";
        showStartupLaunchMessage = false;
        disabledTrayIcon = true;
        filenamePattern = "%F-%H%M%S";
        startupLaunch = true;
        saveAfterCopy = true;
      };
    };
  };

}
