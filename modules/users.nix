{ user, pkgs-unstable, ... }:
{
  users = {
    mutableUsers = false;
    users.${user.name} = {
      isNormalUser = true;
      home = "/home/${user.name}";
      extraGroups = [ "docker" "wheel" ];
      shell = pkgs-unstable.zsh;
      hashedPassword = user.hashedPassword;
      openssh.authorizedKeys.keys = [
        user.sshKey
      ];
    };
  };
}
