{ pkgs, ... }:

{
    services.polybar = {
        enable = true;
        config = ../config/polybar.ini;
        script = ''
            # add needed commands to PATH (for xrandr, grep, sed, route)
            export PATH="$PATH:${pkgs.xlibs.xrandr}/bin:${pkgs.gnugrep}/bin:${pkgs.gnused}/bin:${pkgs.nettools}/bin"

            # get main monitor's resolution
            RESOLUTION=$(xrandr | grep -E "connected primary" | sed -e "s/.*connected primary//" | sed -e "s/\s(.*//" | sed -e "s/\s//")

            # get main internet interface
            interface=$(route | grep '^default' | grep -o '[^ ]*$')

            if [ "$RESOLUTION" = "3840x2160+0+0" ]; then
                width="98%"
                height="64"
                offset="1%"
                font0="Inconsolata:bold:size=18;1.5"
                font1="TerminessTTF Nerd Font Mono:size=30;2"
                font2="M+ 1mn:bold:pixelsize=14;0; ; for Chinese/Japanese numerals (ttf-mplus)"
                left="bspwm"
                center="xwindow"
                right="updates-pacman-aurhelper sep network sep date sep pulseaudio"
            else
                width="96%"
                height="48"
                offset="2%"
                font0="Inconsolata:bold:size=12;1.5"
                font1="TerminessTTF Nerd Font Mono:size=18;2"
                font2="M+ 1mn:bold:pixelsize=10;0; ; for Chinese/Japanese numerals (ttf-mplus)"
                left="bspwm xwindow"
                center=" "
                right="filesystem sep network sep date sep pulseaudio"
            fi

            # Launch bar
            primaryMonitor=$(xrandr | grep -E " connected primary" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
            WIDTH=$width HEIGHT=$height OFFSET=$offset FONT0=$font0 FONT1=$font1 FONT2=$font2 LEFT=$left CENTER=$center RIGHT=$right INTERFACE=$interface MONITOR=$primaryMonitor polybar mybar &
        '';
    };
}
