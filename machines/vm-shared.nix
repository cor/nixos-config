{ config, pkgs, lib, currentSystem, currentSystemName, ... }:
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
    binaryCaches = [ 
      "https://nix-community.cachix.org/" 
      "https://mitchellh-nixos-config.cachix.org" 
      "https://composable-community.cachix.org/" 
    ];
    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "mitchellh-nixos-config.cachix.org-1:bjEbXJyLrL1HZZHBbO4QALnI5faYZppzkU4D2s0G8RQ="    
      "composable-community.cachix.org-1:GG4xJNpXJ+J97I8EyJ4qI5tRTAJ4i7h+NK2Z32I8sK8="
    ];  
  }; 
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
  services.xrdp.defaultWindowManager = "awesome";

  services.xserver = {
    resolutions = [ { x = 5120; y = 2880; } ];
    dpi = 192;
    autorun = true;
    enable = true;
    desktopManager = {
      xfce.enable = true;
    };
    displayManager = {
      xserverArgs = ["-dpi 192"];
      defaultSession = "none+awesome";
      lightdm = {
        enable = true;
      };

      sessionCommands = ''
        eval $(/run/wrappers/bin/gnome-keyring-daemon --start --daemonize) 
        export SSH_AUTH_SOCK
        xr-5k
        ${pkgs.xorg.xset}/bin/xset r rate 250 30
        pamixer --set-volume 100
        pamixer --unmute
      '';
    };

    windowManager = {
      awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [
          luarocks # is the package manager for Lua modules
          luadbi-mysql # Database abstraction layer
        ];
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
    git
    gnumake
    killall
    niv
    rxvt_unicode
    xclip
    docker-client

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
  
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";  
    EDITOR = "hx";
    VISUAL = "hx";
  };

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
