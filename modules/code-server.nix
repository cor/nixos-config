{ user, pkgs, ... }:
{
  services.code-server = let baseDir = "/home/${user.name}/.code-server-nix/"; in {
    enable = false;
    port = 42042;
    host = "0.0.0.0";
    disableTelemetry = true;
    user = user.name;
    extraEnvironment = {
      SSH_AUTH_SOCK = "/home/${user.name}/.ssh/ssh_auth_sock";
    };
    extensionsDir = "${baseDir}extensions";
    userDataDir = "${baseDir}user-data";
    hashedPassword = user.codeHashedPassword;
  };
}
