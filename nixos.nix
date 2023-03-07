{ inputs, pkgs, pkgs-unstable, lib, currentSystemName, ... }: 
{
  nix = import ./nix.nix pkgs-unstable.nix;

  fonts.fonts = with pkgs-unstable; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    ibm-plex
    fira-code
    fira-code-symbols
    jetbrains-mono
  ];

  networking = {
    nameservers = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
    hostName = "CorBook-NixOS";
    firewall.enable = false;
    useDHCP = false;    
  };

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
    xserver = import ./services/xserver.nix pkgs;
    openssh = import ./services/openssh.nix;    
  };


  users.mutableUsers = false;

 
  programs.zsh = {
    enable = true;  # default shell on catalina
    promptInit = "";
  };

  users.users.cor = {
    isNormalUser = true;
    home = "/home/cor";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.zsh;
    hashedPassword = "$6$sb3eB/EbsWnfAqzy$szu0h/hbX9/23n5RKE0dwzV8lmq.1Yj2NzI/jYQxJZIbzmY8dpIYRdhUVZgCMnR0CeqrQfgzs6FtPoGUiCqDR0";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAN0JRbnTsz4eEUeL6My/ew+rX3Qojawn+Y1B3buPuyC"
    ];
  };
}
