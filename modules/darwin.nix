{ config, pkgs, ... }:

{
  services.nix-daemon.enable = true;

  environment = {
    systemPackages = with pkgs; [ 
      gnumake 
      coreutils 
      cmake 
      kitty 
      element-desktop
      vscodium
      gh
    ];

    variables = import ./environment/variables.nix;
    shells = [ pkgs.zsh ];
  };


  networking = let name = "CorBook"; in {
    computerName = name;
    hostName = name;
    localHostName = name;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
