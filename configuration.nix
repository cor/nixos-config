# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "CorBook-NixOS"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.ens33.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  environment.etc = {
    "bspwmrc".source = ./.config/bspwm/bspwmrc;
    "sxhkdrc".source = ./.config/bspwm/sxhkdrc;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "scale";
    };

    displayManager = {
      defaultSession = "none+bspwm";
      # sessionCommands = ''
      #   ${pkgs.xlibs.xset}/bin/xset r rate 200 40
      # '';
    };

    windowManager = {
      bspwm = {
        enable = true;
        configFile = "/etc/bspwmrc";
        sxhkd.configFile = "/etc/sxhkdrc";
      };
    };
  };






  # Enable the GNOME 3 Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome3.enable = true;
  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cor = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
  };

  home-manager.users.cor = {pkgs, ... }: {
    home.file.".background-image".source = ./wallpapers/mountains.jpg;
    gtk.enable = true;
    gtk.theme = {
      package = pkgs.theme-vertex;
      name = "Vertex-Dark";
    };

    programs.git = {
      enable = true;
      userName = "cor";
      userEmail = "cor@pruijs.nl";
    };

    programs.alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
      };
    };

    programs.zsh = {
      enable = true;

      enableCompletion = true;
      enableAutosuggestions = true;
      
      prezto = {
        enable = true;
        color = true;
        pmodules = [
        "environment"
        "terminal"
        "editor"
        "history"
        "directory"
        "spectrum"
        "utility"
        "completion"
        "git"
        "syntax-highlighting"
        "history-substring-search"
        "prompt"
        ];
      };
    };

  #   services.polybar = {
  #     enable = true;
  #     config = ./.config/nixpkgs/config/polybar.ini;
  #     script = ''
  #         # add needed commands to PATH (for xrandr, grep, sed, route)
  #         export PATH="$PATH:${pkgs.xlibs.xrandr}/bin:${pkgs.gnugrep}/bin:${pkgs.gnused}/bin:${pkgs.nettools}/bin"

  #         # get main monitor's resolution
  #         RESOLUTION=$(xrandr | grep -E "connected primary" | sed -e "s/.*connected primary//" | sed -e "s/\s(.*//" | sed -e "s/\s//")

  #         # get main internet interface
  #         interface=$(route | grep '^default' | grep -o '[^ ]*$')

  #         if [ "$RESOLUTION" = "3840x2160+0+0" ]; then
  #             width="98%"
  #             height="64"
  #             offset="1%"
  #             font0="Inconsolata:bold:size=18;1.5"
  #             font1="TerminessTTF Nerd Font Mono:size=30;2"
  #             font2="M+ 1mn:bold:pixelsize=14;0; ; for Chinese/Japanese numerals (ttf-mplus)"
  #             left="bspwm"
  #             center="xwindow"
  #             right="updates-pacman-aurhelper sep network sep date sep pulseaudio"
  #         else
  #             width="96%"
  #             height="48"
  #             offset="2%"
  #             font0="Inconsolata:bold:size=12;1.5"
  #             font1="TerminessTTF Nerd Font Mono:size=18;2"
  #             font2="M+ 1mn:bold:pixelsize=10;0; ; for Chinese/Japanese numerals (ttf-mplus)"
  #             left="bspwm xwindow"
  #             center=" "
  #             right="filesystem sep network sep date sep pulseaudio"
  #         fi

  #         # Launch bar
  #         primaryMonitor=$(xrandr | grep -E " connected primary" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
  #         WIDTH=$width HEIGHT=$height OFFSET=$offset FONT0=$font0 FONT1=$font1 FONT2=$font2 LEFT=$left CENTER=$center RIGHT=$right INTERFACE=$interface MONITOR=$primaryMonitor polybar mybar &
  #     '';
  #   };

  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; let
    extensions = (with pkgs.vscode-extensions; [
      ms-python.python
    ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
      name = "nix";
      publisher = "bbenoist";
      version = "1.0.1";
      sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
  }]; vscode-with-extensions = pkgs.vscode-with-extensions.override {
      vscodeExtensions = extensions;
    };
  in 
  [
    zsh
    zsh-prezto
    gnumake
    killall
    niv
    rxvt_unicode
    xclip
    tree
    rofi
    polybar
    wget vim
    firefox
    google-chrome
    gtkmm3
    git
    rustup
    vscode-with-extensions
    jetbrains.clion
    neofetch
    htop
    ghc
    haskellPackages.haskell-language-server
    gcc gdb cmake llvm clang-tools clang
    _1password
    discord
    slack
    scrot
    openssl
    binutils
  ];

  virtualisation.vmware.guest.enable = true;
  virtualisation.docker.enable = true;

 
  users.defaultUserShell = pkgs.zsh;
  nixpkgs.config.allowUnfree = true;




  programs.dconf.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

