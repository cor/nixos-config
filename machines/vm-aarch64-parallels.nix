{ config, pkgs, lib, modulesPath, ... }: {
  imports = [
    # Parallels is qemu under the covers. This brings in important kernel
    # modules to get a lot of the stuff working.
    (modulesPath + "/profiles/qemu-guest.nix")

    ./vm-shared.nix
  ];

  # services.xserver.extraLayouts.mac-backtick-fix = {
  #   description = "US(mac) layout with swapped backtick (grave) and section (paragraph) keys in order to work with Apple ISO keyboards";
  #   languages = [ "eng" ];
  #   symbolsFile = ../symbols/mac-backtick-fix;
  # };

  # services.xserver.layout = "mac-backtick-fix";

  # Interface is this on my M1
  networking.interfaces.enp0s5.useDHCP = true;

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
}
