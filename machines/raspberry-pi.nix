{ pkgs, inputs, currentSystemName, ... }: {

  networking = {
    hostName = currentSystemName;
    useDHCP = false;
    interfaces = { eth0.useDHCP = true; };
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    firewall = {
      allowedTCPPorts = [ 443 80 26656 22 ];
      allowPing = true;
    };
  };
  environment.systemPackages = with pkgs; [ bluez bluez-tools ];

  raspberry-pi-nix.board = "bcm2712"; # pi5, cfr: https://www.raspberrypi.com/documentation/computers/linux_kernel.html#native-build-configuration
  
  hardware = {
    bluetooth.enable = true;
    raspberry-pi.config.all = {
      base-dt-params = {
        # enable autoprobing of bluetooth driver
        # https://github.com/raspberrypi/linux/blob/c8c99191e1419062ac8b668956d19e788865912a/arch/arm/boot/dts/overlays/README#L222-L224
        krnbt = {
          enable = true;
          value = "on";
        };
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  # As this is intended as a stadalone image, undo some of the minimal profile stuff
  documentation.enable = true;
  documentation.nixos.enable = true;
}
