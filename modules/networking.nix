{ ... }:
{
  networking = {
    networkmanager.enable = true;
    networkmanager.dns = "none";
    resolvconf.enable = true;
    nameservers = [ "1.1.1.1" "1.0.0.1" "9.9.9.9" ];

    # Fix for iPhone hotspot
    # https://discourse.nixos.org/t/networking-problem-in-new-nixos-install/12041
    # use `ip link` to confirm.
    # 
    # interfaces.eth0.mtu = 1400;
    # 
    # commented out because it made startup slow if eth0 is not connected.

    # block trackers, annoyances, AI-generated content, and distractions.
    extraHosts =
      let
        blacklist = [
          "9to5mac.com"
          "ad.nl"
          "engadget.com"
          "facebook.com"
          "instagram.com"
          "lobste.rs"
          "macrumors.com"
          "medium.com"
          "netflix.com"
          "news.ycombinator.com"
          "nintendolife.com"
          "nos.nl"
          "nrc.nl"
          "nu.nl"
          "old.reddit.com"
          "polygon.com"
          "reddit.com"
          "rtl.nl"
          "theverge.com"
          "tiktok.com"
          "tweakers.net"
          "twitter.com"
          "vice.com"
          "x.com"
          "youtube.com"
        ];
      in
      builtins.concatStringsSep "\n" (builtins.concatMap
        (domain:
          [ "127.0.0.1 ${domain}" "127.0.0.1 www.${domain}" ]
        )
        blacklist);
  };

  services.resolved.enable = false;
}
