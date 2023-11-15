{ config, pkgs, lib, modulesPath, ... }: {
  system.stateVersion = "23.05";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.rosetta.enable = true;
  services.spice-vdagentd.enable = true; # copy and paste with Virtualization.framework
}
