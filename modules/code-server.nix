{ pkgs, ... }:
{
  services.code-server = let baseDir = "/home/cor/.code-server-nix/"; in {
    enable = true;
    port = 42042;
    host = "0.0.0.0";
    disableTelemetry = true;
    user = "cor";
    extraEnvironment = {
      SSH_AUTH_SOCK = "/home/cor/.ssh/ssh_auth_sock";
    };
    extensionsDir = "${baseDir}extensions";
    userDataDir = "${baseDir}user-data";
    hashedPassword = "$argon2i$v=19$m=4096,t=3,p=1$EhoOotFaUezZdQ+6Nfaz6w$ba74RTp6245H0K0URZmDsV1GBmVSHwzF5BT42FA9Y3I";
  };
}
