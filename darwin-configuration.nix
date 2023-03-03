{ config, pkgs, ... }:

{
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [ 
    gnumake 
    coreutils 
    cmake 
    kitty 
    element-desktop
    vscodium
  ];

  environment.variables = {
    PS1="%d $ ";
    PROMPT="%d $ ";
    RPROMPT="";
    EDITOR="hx";
  };

  environment.shells = [ pkgs.zsh ];

  networking = let name = "CorBook"; in {
    computerName = name;
    hostName = name;
    localHostName = name;
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true;  # default shell on catalina
    promptInit = "";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
