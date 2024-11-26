{ pkgs, ... }:
{
  services.openvscode-server = {
    enable = true;
    port = 42042;
    telemetryLevel = "off";
    user = "cor";
  };
}
