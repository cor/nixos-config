{ pkgs, ... }:
{
  services.openvscode-server = let baseDir = "/home/cor/.openvscode-server-nix/"; in {
    enable = true;
    port = 42042;
    telemetryLevel = "off";
    user = "cor";
    extraEnvironment = {
      # TODO: make non-orbstack specific
      SSH_AUTH_SOCK = "/opt/orbstack-guest/run/host-ssh-agent.sock";
    };
    extensionsDir = "${baseDir}extensions";
    serverDataDir = "${baseDir}server-data";
    userDataDir = "${baseDir}user-data";
  };
}
