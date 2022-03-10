# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  discord-chromium = pkgs.makeDesktopItem rec {
    name = "Discord";
    desktopName = "Discord";
    genericName = "All-in-one cross-platform voice and text chat for gamers";
    exec = "${pkgs.chromium}/bin/chromium --app=\"https://discord.com/channels/@me\"";
    icon = "discord";
    type = "Application";
    terminal = false;
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./machines/vm-aarch64.nix
      (import "${home-manager}/nixos")
      ./home.nix
    ];
  hardware.video.hidpi.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  environment.etc = {
    "bspwmrc".source = ./bspwm/bspwmrc;
    "sxhkdrc".source = ./bspwm/sxhkdrc;
  };

  # begin retina
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };
  # end retina


  # Enable the X11 windowing system.
  services.xserver = {
    autorun = true;
    enable = true;
    displayManager = {
      defaultSession = "none+bspwm";
      lightdm.enable = true;
      sessionCommands = ''
        eval $(/run/wrappers/bin/gnome-keyring-daemon --start --daemonize) 
        export SSH_AUTH_SOCK
        xrandr-mbp-retina
        ${pkgs.xorg.xset}/bin/xset r rate 200 40
        pamixer --set-volume 100
        pamixer --unmute
        polybar main &

      ''; # somehow homemanager doesn't automatically start polybar
    };
    # windowManager.i3.enable = true; 
    # dpi = 96;
    dpi = 192;
    windowManager = {
      bspwm = {
        enable = true;
        configFile = "/etc/bspwmrc";
        sxhkd.configFile = "/etc/sxhkdrc";
      };
    };
    libinput = {
      enable = true;

      # disabling mouse acceleration
      mouse = {
        accelProfile = "flat";
      };

      # enable touchpad acceleration
      touchpad = {
        accelProfile = "adaptive";
      };
    };
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts
    dina-font
    proggyfonts
    inconsolata
    inconsolata-nerdfont
    ibm-plex
  ];


  
  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  virtualisation.vmware.guest.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.3
  users.users.cor = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };
  users.defaultUserShell = pkgs.zsh;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pamixer
    rofi
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
    tree
    git
    git-lfs
    polybar
    coreutils-full
    binutils
    gnome3.gnome-control-center
    xclip
    curl
    ripgrep
    chromium
    gtkmm3 # needed for the vmware user tools clipboard
    neofetch
    pinentry
    pinentry-curses
    kitty
    zip
    openssh
    discord-chromium
    (writeShellScriptBin "xrandr-mbp" ''
      xrandr --newmode "1512x945_60.00"  118.00  1512 1608 1760 2008  945 948 958 981 -hsync +vsync
      xrandr --addmode Virtual-1 1512x945_60.00
      xrandr -s 1512x945_60.00
      polybar-msg cmd restart
    '')
    (writeShellScriptBin "xrandr-mbp-retina" ''
      xrandr --newmode "3024x1890_60.00"  488.50  3024 3264 3592 4160  1890 1893 1899 1958 -hsync +vsync
      xrandr --addmode Virtual-1 3024x1890_60.00
      xrandr -s 3024x1890_60.00
      polybar-msg cmd restart
    '')
    (writeShellScriptBin "xrandr-uw" ''
      xrandr --newmode "3440x1440_60.00"  419.50  3440 3696 4064 4688  1440 1443 1453 1493 -hsync +vsync
      xrandr --addmode Virtual-1 3440x1440_60.00
      xrandr -s 3440x1440_60.00
      polybar-msg cmd restart
    '')
    (writeShellScriptBin "xrandr-1440" ''
      xrandr --newmode "2560x1440_60.00"  312.25  2560 2752 3024 3488  1440 1443 1448 1493 -hsync +vsync
      xrandr --addmode Virtual-1 2560x1440_60.00
      xrandr -s 2560x1440_60.00
      polybar-msg cmd restart
    '')
    (writeShellScriptBin "reload-config" ''
       sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch
    '')
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gnome3";
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
  # services.openssh.startAgent = true;


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
  system.stateVersion = "22.05"; # Did you read the comment?
  nix.package = pkgs.nixUnstable;
 		nix.extraOptions = "experimental-features = nix-command flakes";
   			services.openssh.enable = true;
 		services.openssh.passwordAuthentication = true;
}

