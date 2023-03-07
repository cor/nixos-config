{ ... }:
{
  networking = {
    # Interface is this on my M1
    interfaces.enp0s5.useDHCP = true;
 
    nameservers = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
    hostName = "CorBook-NixOS";
    firewall.enable = false;
    useDHCP = false;    
  };
}