{ config, pkgs, lib, modulesPath, ... }: {
  system.stateVersion = "23.05";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

}
