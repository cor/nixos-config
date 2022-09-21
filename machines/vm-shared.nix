{ config, pkgs, lib, currentSystem, currentSystemName, ... }:

let

  # bash script to let dbus know about important env variables and
  # propogate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts  
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
      '';
  };

in
{
  # Be careful updating this.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # use unstable nix so we can access flakes
  nix = {
    package = pkgs.nixUnstable;
    useSandbox = "relaxed";
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # We expect to run the VM on hidpi machines.
  hardware.video.hidpi.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # VMware, Parallels both only support this being 0 otherwise you see
  # "error switching console mode" on boot.
  boot.loader.systemd-boot.consoleMode = "0";

  # Define your hostname.
  networking.hostName = "dev";

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  # Virtualization settings
  virtualisation.docker.enable = true;
  # virtualisation.podman = {
  #   enable = true;
  #   dockerSocket.enable = true;
  #   defaultNetwork.dnsname.enable = true;
  # };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # setup windowing environment
  services.xrdp.defaultWindowManager = "bspwm";

  # services.xserver = {

  #   autorun = true;
  #   enable = true;
  #   desktopManager = {
  #     # xterm.enable = false;
  #     xfce.enable = true;
  #     # wallpaper.mode = "fill";
  #   };
  #   displayManager = {
  #     defaultSession = "xfce+bspwm";
  #     lightdm.enable = true;

  #     # autoLogin.enable = true;
  #     # autoLogin.user = "cor";
  #     sessionCommands = ''
  #       eval $(/run/wrappers/bin/gnome-keyring-daemon --start --daemonize) 
  #       export SSH_AUTH_SOCK
  #       xr-mbp
  #       ${pkgs.xorg.xset}/bin/xset r rate 400 70
  #       pamixer --set-volume 100
  #       pamixer --unmute
  #       polybar main &
  #     ''; # somehow homemanager doesn't automatically start polybar
  #   };
  #   dpi = 192;
  #   windowManager = {
  #     bspwm = {
  #       enable = true;
  #       configFile = ../bspwm/bspwmrc;
  #       sxhkd.configFile = ../bspwm/sxhkdrc;
  #     };
  #   };
  #   libinput = {
  #     enable = true;

  #     # disabling mouse acceleration
  #     mouse = {
  #       accelProfile = "flat";
  #     };

  #     # enable touchpad acceleration
  #     touchpad = {
  #       accelProfile = "adaptive";
  #     };
  #   };
  # };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };


  # programs.sway = {
  #   enable = true;
  #   wrapperFeatures.gtk = true;
  # };



  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;

  # Manage fonts. We pull these from a secret directory since most of these
  # fonts require a purchase.
  fonts = {
    fontDir.enable = true;

    fonts = [
      pkgs.fira-code
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnumake
    killall
    niv
    rxvt_unicode
    xclip
    docker-client

    alacritty # gpu accelerated terminal
    sway
    dbus-sway-environment
    configure-gtk
    wayland
    glib # gsettings
    dracula-theme # gtk theme
    gnome3.adwaita-icon-theme  # default gnome cursors
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    bemenu # wayland clone of dmenu
    mako # notification system developed by swaywm maintainer
    
        
    # For hypervisors that support auto-resizing, this script forces it.
    # I've noticed not everyone listens to the udev events so this is a hack.
    (writeShellScriptBin "xrandr-auto" ''
      xrandr --output Virtual-1 --auto
    '')

    # Some VMs do not support automatic resizing yet and on
    # my big monitor it doesn't detect the resolution either so we just
    # manualy create the resolution and switch to it with this script.
    # This script could be better but its hopefully temporary so just force it.
    (writeShellScriptBin "xr-mbp" ''
      xrandr --newmode "3024x1890_60.00"  488.50  3024 3264 3592 4160  1890 1893 1899 1958 -hsync +vsync
      xrandr --addmode Virtual-1 3024x1890_60.00
      xrandr -s 3024x1890_60.00
      polybar-msg cmd restart
      feh-bg-fill
    '')
    (writeShellScriptBin "xr-mbp-1.5" ''
      xrandr --newmode "4536x2835_60.00"  1111.25  4536 4928 5424 6312  2835 2838 2848 2935 -hsync +vsync
      xrandr --addmode Virtual-1 4536x2835_60.00
      xrandr -s 4536x2835_60.00
      polybar-msg cmd restart
      feh-bg-fill
    '')
    (writeShellScriptBin "xr-uw" ''
      xrandr --newmode "6600x2880_60.00"  1644.25  6600 7168 7896 9192  2880 2883 2893 2982 -hsync +vsync
      xrandr --addmode Virtual-1 6600x2880_60.00
      xrandr -s 6600x2880_60.00
      polybar-msg cmd restart
      feh-bg-fill
    '')
    (writeShellScriptBin "xr-5120" ''
      xrandr --newmode "5120x2880_60.00"  1275.49  5120 5560 6128 7136  2880 2881 2884 2979  -hsync +vsync
      xrandr --addmode Virtual-1 5120x2880_60.00
      xrandr -s 5120x2880_60.00
      polybar-msg cmd restart
      feh-bg-fill
    '')
    (writeShellScriptBin "xr-3840" ''
      xrandr --newmode "3840x2160_60.00"  712.75  3840 4160 4576 5312  2160 2163 2168 2237 -hsync +vsync
      xrandr --addmode Virtual-1 3840x2160_60.00
      xrandr -s 3840x2160_60.00
      polybar-msg cmd restart
      feh-bg-fill
    '')
    (writeShellScriptBin "xr-5760" ''
      xrandr --newmode "5760x3240_60.00"  1619.25  5760 6264 6904 8048  3240 3243 3248 3354 -hsync +vsync
      xrandr --addmode Virtual-1 5760x3240_60.00
      xrandr -s 5760x3240_60.00
      polybar-msg cmd restart
      feh-bg-fill
    '')
    (writeShellScriptBin "xr-6400" ''
      xrandr --newmode "6400x3600_60.00"  2003.00  6400 6968 7680 8960  3600 3603 3608 3726 -hsync +vsync
      xrandr --addmode Virtual-1 6400x3600_60.00
      xrandr -s 6400x3600_60.00
      polybar-msg cmd restart
      feh-bg-fill
    '')
    (writeShellScriptBin "xr-square" ''
      xrandr --newmode "2880x2880_60.00"  718.25  2880 3128 3448 4016  2880 2883 2893 2982 -hsync +vsync      
      xrandr --addmode Virtual-1 2880x2880_60.00 
      xrandr -s 2880x2880_60.00 
      polybar-msg cmd restart
      feh-bg-fill
    '')
    (writeShellScriptBin "xr-4-3" ''
      xrandr --newmode "3840x2880_60.00"  955.75  3840 4168 4592 5344  2880 2883 2887 2982 -hsync +vsync      
      xrandr --addmode Virtual-1 3840x2880_60.00 
      xrandr -s 3840x2880_60.00 
      polybar-msg cmd restart
      feh-bg-fill
    '')
    (writeShellScriptBin "xr-vertical" ''
      xrandr --newmode "2880x5120_60.00"  1286.50  2880 3144 3464 4048  5120 5123 5133 5298 -hsync +vsync
      xrandr --addmode Virtual-1 2880x5120_60.00
      xrandr -s 2880x5120_60.00
      polybar-msg cmd restart
      feh-bg-fill
    '')
    (writeShellScriptBin "xr-things-sidebar" ''
      xrandr --newmode "4296x2880_60.00"  1071.75  4296 4672 5144 5992  2880 2883 2893 2982 -hsync +vsync      
      xrandr --addmode Virtual-1 4296x2880_60.00
      xrandr -s 4296x2880_60.00
      polybar-msg cmd restart
      feh-bg-fill
    '')
    (writeShellScriptBin "docker-stop-all" ''
      docker stop $(docker ps -q)
      docker system prune -f
    '')
    (writeShellScriptBin "docker-prune-all" ''
      docker-stop-all
      docker rmi -f $(docker images -a -q)    
      docker volume prune -f
    '')
  ] ++ lib.optionals (currentSystemName == "vm-aarch64") [
    # This is needed for the vmware user tools clipboard to work.
    # You can test if you don't need this by deleting this and seeing
    # if the clipboard sill works.
    gtkmm3

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  services.openssh.permitRootLogin = "no";

  # Disable the firewall since we're in a VM and we want to make it
  # easy to visit stuff in here. We only use NAT networking anyways.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
