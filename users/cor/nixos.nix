{ pkgs, ... }:

{
  # https://github.com/nix-community/home-manager/pull/2408
  # environment.pathsToLink = [ "/share/fish" ];
  
  environment.systemPackages = with pkgs; [
    bspwm
    sxhkd
  ];

  users.users.cor = {
    isNormalUser = true;
    home = "/home/cor";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.zsh;
    hashedPassword = "$6$sb3eB/EbsWnfAqzy$szu0h/hbX9/23n5RKE0dwzV8lmq.1Yj2NzI/jYQxJZIbzmY8dpIYRdhUVZgCMnR0CeqrQfgzs6FtPoGUiCqDR0";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIYMXAekVupSqJ2gDqJvtehePc+J8J7gZant6C4375H3 cor@pruijs.nl"
    ];
  };
}
