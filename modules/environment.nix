{ machine, inputs, pkgs, lib, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      git
      git-lfs
      file
      gnumake
      killall
      unzip
      # rxvt_unicode
      # xclip
      docker-client
      # arc-theme
      # nnn
      trash-cli
      (writeShellScriptBin "docker-stop-all" ''
        docker stop $(docker ps -q)
        docker system prune -f
      '')
      (writeShellScriptBin "docker-prune-all" ''
        docker-stop-all
        docker rmi -f $(docker images -a -q)    
        docker volume prune -f
      '')
    ];

    variables = {
      PS1 = "%m %d $ ";
      PROMPT = "%m %d $ ";
      RPROMPT = "";
      EDITOR = "hx";
      VISUAL = "hx";
      NNN_TRASH = "1"; # let nnn trash instead of rm

      #   # 2x ("retina"') scaling on Linux
    } // (if machine.headless then { } else {
      GDK_SCALE = "2";
      GDK_DPI_SCALE = "0.5";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_SCALE_FACTOR = "2";
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
      # NIXOS_OZONE_WL = "1";
      # ELECTRON_OZONE_PLATFORM_HINT = "auto"; # let electron programs use Wayland. suggested in the niri matrix
    });

    # required for zsh autocomplete
    pathsToLink = [ "/share/zsh" ];
  };
}
