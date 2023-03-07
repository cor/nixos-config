inputs: { pkgs, lib, currentSystemName, ... }: 
let 
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.system; config.allowUnfree = true; };

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
      xrandr --dpi 192 
    '';
in
{
  nix = import ./nix.nix pkgs-unstable.nix;

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    ibm-plex
    fira-code
    fira-code-symbols
    jetbrains-mono
  ];

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
  networking.hostName = "dev";
  networking.firewall.enable = false;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.video.hidpi.enable = true;
  networking.useDHCP = false;
  security.sudo.wheelNeedsPassword = false;

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  virtualisation.docker.enable = true;


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
        xset-r-slow
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

  users.mutableUsers = false;

  environment = {
    systemPackages = with pkgs; [
      git
      gnumake
      killall
      niv
      rxvt_unicode
      xclip
      docker-client
      arc-theme

      (writeShellScriptBin "xr-auto" ''
        xrandr --output Virtual-1 --auto
      '')
      (mkXr { name = "mbp"; w = 3024; h = 1890; r = 60; })
      (mkXr { name = "mbp-120hz"; w = 3024; h = 1890; r = 120; })
      (mkXr { name = "mbp-1.5"; w = 4536; h = 2835; r = 60; })
      (mkXr { name = "mbp-16"; w = 3456; h = 2160; r = 60; })
      (mkXr { name = "4k"; w = 3840; h = 2160; r = 60; })
      (mkXr { name = "5k"; w = 5120; h = 2880; r = 60; })
      (mkXr { name = "5k-30hz"; w = 5120; h = 2880; r = 30; })
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

    variables = import ./environment/variables.nix;
  };
 
  services.openssh = import ./services/openssh.nix;

  
  programs.zsh = {
    enable = true;  # default shell on catalina
    promptInit = "";
  };

  
  # required for zsh autocomplete
  environment.pathsToLink = [ "/share/zsh" ];

  users.users.cor = {
    isNormalUser = true;
    home = "/home/cor";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.zsh;
    hashedPassword = "$6$sb3eB/EbsWnfAqzy$szu0h/hbX9/23n5RKE0dwzV8lmq.1Yj2NzI/jYQxJZIbzmY8dpIYRdhUVZgCMnR0CeqrQfgzs6FtPoGUiCqDR0";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAN0JRbnTsz4eEUeL6My/ew+rX3Qojawn+Y1B3buPuyC"
    ];
  };
}
