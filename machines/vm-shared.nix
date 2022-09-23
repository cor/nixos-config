{ config, pkgs, lib, currentSystem, currentSystemName, ... }:
let
  mkXr = { name ? "", w, h, r }:
    let
      modeName = "${toString w}x${toString h}_${toString r}.00";
      scriptName = if lib.stringLength name == 0 then modeName else name;
    in
    pkgs.writeShellScriptBin "xr-${scriptName}" ''
      # xrandr doesn't parse the output correctly when you use $()      
      # therefore we use eval instead
      MODELINE=$(cvt ${toString w} ${toString h} ${toString r} | tail -n 1 | cut -d " " -f2-) 
      eval "xrandr --newmode $MODELINE" 
      xrandr --addmode Virtual-1 ${modeName}
      xrandr -s ${modeName}
      polybar-msg cmd restart
      feh-bg-fill
    '';
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

  services.xserver = {
    autorun = true;
    enable = true;
    desktopManager = {
      # xterm.enable = false;
      xfce.enable = true;
      # wallpaper.mode = "fill";
    };
    displayManager = {
      defaultSession = "xfce+bspwm";
      lightdm.enable = true;

      # autoLogin.enable = true;
      # autoLogin.user = "cor";
      sessionCommands = ''
        eval $(/run/wrappers/bin/gnome-keyring-daemon --start --daemonize) 
        export SSH_AUTH_SOCK
        xr-mbp
        ${pkgs.xorg.xset}/bin/xset r rate 400 70
        pamixer --set-volume 100
        pamixer --unmute
        polybar main &
      ''; # somehow homemanager doesn't automatically start polybar
    };
    dpi = 192;
    windowManager = {
      bspwm = {
        enable = true;
        configFile = ../bspwm/bspwmrc;
        sxhkd.configFile = ../bspwm/sxhkdrc;
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

    # For hypervisors that support auto-resizing, this script forces it.
    # I've noticed not everyone listens to the udev events so this is a hack.
    (writeShellScriptBin "xr-auto" ''
      xrandr --output Virtual-1 --auto
      polybar-msg cmd restart
      feh-bg-fill
    '')
    (mkXr { name = "mbp"; w = 3024; h = 1890; r = 60; })
    (mkXr { name = "mbp-1.5"; w = 4536; h = 2835; r = 60; })
    (mkXr { name = "4k"; w = 3840; h = 2160; r = 60; })
    (mkXr { name = "5k"; w = 5120; h = 2880; r = 60; })
    (mkXr { name = "5.5k"; w = 5760; h = 3240; r = 60; })
    (mkXr { name = "6k"; w = 6400; h = 3600; r = 60; })
    (mkXr { name = "square"; w = 2880; h = 2880; r = 60; })
    (mkXr { name = "vertical-studio-display"; w = 2880; h = 5120; r = 60; })
    (mkXr { name = "things-sidebar"; w = 4296; h = 2880; r = 60; })
    (mkXr { name = "4-3"; w = 3840; h = 2880; r = 60; })
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
