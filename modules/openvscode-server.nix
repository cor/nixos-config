{ pkgs, ... }:
{
  services.openvscode-server = {
    enable = true;
    port = 42042;
    telemetryLevel = "off";
    user = "cor";
    extraEnvironment = {
      # TODO: make non-orbstack specific
      SSH_AUTH_SOCK = "/opt/orbstack-guest/run/host-ssh-agent.sock";
    };
  };
}
