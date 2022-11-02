{ pkgs, chromium }: {name, genericName, url }:  
  pkgs.makeDesktopItem rec {
    inherit name;
    inherit genericName;
    desktopName = name;
    icon = name;
    exec = "${chromium}/bin/chromium --app=\"${url}\"";
    type = "Application";
    terminal = false;
  }
