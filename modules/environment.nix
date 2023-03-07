{ pkgs, lib, currentSystemName, ... }: 
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
    xrandr --dpi 192 
  '';
in
{  
  environment = {
    systemPackages = with pkgs; [
      git
      git-lfs
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

    variables = import ../environment/variables.nix;

    # required for zsh autocomplete
    pathsToLink = [ "/share/zsh" ];
  };
}
