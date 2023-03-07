pkgs: {
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
}
