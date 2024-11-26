{ pkgs, ... }:
{
  services.code-server = let baseDir = "/home/cor/.code-server-nix/"; in {
    enable = true;
    port = 42042;
    disableTelemetry = true;
    user = "cor";
    extraEnvironment = {
      # TODO: make non-orbstack specific
      SSH_AUTH_SOCK = "/opt/orbstack-guest/run/host-ssh-agent.sock";
    };
    extensionsDir = "${baseDir}extensions";
    userDataDir = "${baseDir}user-data";
    hashedPassword = "$argon2i$v=19$m=4096,t=3,p=1$EhoOotFaUezZdQ+6Nfaz6w$ba74RTp6245H0K0URZmDsV1GBmVSHwzF5BT42FA9Y3I";
  };
}
