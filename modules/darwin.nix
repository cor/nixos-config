{ config, pkgs, machine, ... }:

{
  services.nix-daemon.enable = true;

  environment = {
    systemPackages = with pkgs; [
      gnumake
      coreutils
      cmake
      gh
    ];

    variables = {
      PS1 = "%m %d $ ";
      PROMPT = "%m %d $ ";
      RPROMPT = "";
      EDITOR = "hx";
      VISUAL = "hx";
      NNN_TRASH = "1"; # let nnn trash instead of rm
    };

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
