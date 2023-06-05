{ inputs, pkgs, pkgs-unstable, lib, currentSystemName, ... }: 
{
  hardware = {
    pulseaudio.enable = true;
    video.hidpi.enable = true;
  };

  sound.enable = true;
  security = {
    sudo.wheelNeedsPassword = false;
    pam.services.lightdm.enableGnomeKeyring = true;
  };

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  virtualisation.docker.enable = true;

  services = {
    xrdp.defaultWindowManager = "awesome";
    gnome.gnome-keyring.enable = true;
  };

  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];  
}
