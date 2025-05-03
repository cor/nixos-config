{ user, pkgs-unstable, ... }:
{
  users = {
    mutableUsers = false;
    users.${user.name} = {
      isNormalUser = true;
      description = user.name;
      home = "/home/${user.name}";
      extraGroups = [ "networkmanager" "docker" "wheel" ];
      shell = pkgs-unstable.zsh;
      hashedPassword = user.hashedPassword;
      openssh.authorizedKeys.keys = [
        user.sshKey
      ];
    };
  };
}
