{ config, pkgs, ... }:

{
  nix = import ./nix.nix pkgs.nix;
  services.nix-daemon.enable = true;

  environment = {
    systemPackages = with pkgs; [ 
      gnumake 
      coreutils 
      cmake 
      kitty 
      element-desktop
      vscodium
    ];

    variables = {
      PS1="%d $ ";
      PROMPT="%d $ ";
      RPROMPT="";
      EDITOR="hx";
    };

    shells = [ pkgs.zsh ];
  };


  networking = let name = "CorBook"; in {
    computerName = name;
    hostName = name;
    localHostName = name;
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true;  # default shell on catalina
    promptInit = "";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
