{ pkgs-unstable, ... }:
{
  users = {
    mutableUsers = false;
    users.cor = {
      isNormalUser = true;
      home = "/home/cor";
      extraGroups = [ "docker" "wheel" ];
      shell = pkgs-unstable.nushell;
      hashedPassword = "$6$sb3eB/EbsWnfAqzy$szu0h/hbX9/23n5RKE0dwzV8lmq.1Yj2NzI/jYQxJZIbzmY8dpIYRdhUVZgCMnR0CeqrQfgzs6FtPoGUiCqDR0";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAN0JRbnTsz4eEUeL6My/ew+rX3Qojawn+Y1B3buPuyC"
      ];
    };
  };
}
