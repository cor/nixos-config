{ pkgs, inputs, machine, ... }: {

  networking = {
    hostName = machine.name;
    useDHCP = false;
    interfaces = { eth0.useDHCP = true; };
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    firewall = {
      allowedTCPPorts = [ 443 80 26656 22 ];
      allowPing = true;
    };
  };

  # You cannot enter the pi without openssh enabled!
  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [ bluez bluez-tools ];

  raspberry-pi-nix.board = "bcm2712"; # pi5, cfr: https://www.raspberrypi.com/documentation/computers/linux_kernel.html#native-build-configuration

  hardware = {
    bluetooth.enable = true;
    raspberry-pi.config.all = {
      # as per exaple: https://github.com/nix-community/raspberry-pi-nix/blob/aaec735faf81ff05356d65c7408136d2c1522d34/example/default.nix#L17C11-L32C13
      base-dt-params = {
        BOOT_UART = {
          value = 1;
          enable = true;
        };
        uart_2ndstage = {
          value = 1;
          enable = true;
        };
      };
      dt-overlays = {
        disable-bt = {
          enable = true;
          params = { };
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
  system.stateVersion = machine.stateVersion; # Did you read the comment?

  # As this is intended as a stadalone image, undo some of the minimal profile stuff
  documentation.enable = true;
  documentation.nixos.enable = true;
}
