{ pkgs, lib, ... }:
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
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "xr-auto" ''
      xrandr --output Virtual-1 --auto
    '')
  ] ++ map mkXr [
    { name = "mbp"; w = 3024; h = 1890; r = 60; }
    { name = "mbp-120hz"; w = 3024; h = 1890; r = 120; }
    { name = "mbp-1.5"; w = 4536; h = 2835; r = 60; }
    { name = "mbp-16"; w = 3456; h = 2160; r = 60; }
    { name = "4k"; w = 3840; h = 2160; r = 60; }
    { name = "5k"; w = 5120; h = 2880; r = 60; }
    { name = "5k-30hz"; w = 5120; h = 2880; r = 30; }
    { name = "5.5k"; w = 5760; h = 3240; r = 60; }
    { name = "6k"; w = 6400; h = 3600; r = 60; }
    { name = "square"; w = 2880; h = 2880; r = 60; }
    { name = "vertical-studio-display"; w = 2880; h = 5120; r = 60; }
    { name = "things-sidebar"; w = 4296; h = 2880; r = 60; }
    { name = "4-3"; w = 3840; h = 2880; r = 60; }
  ];
}
