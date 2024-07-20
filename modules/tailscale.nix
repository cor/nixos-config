{ ... }:
{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    extraUpFlags = [ "--advertise-exit-node" ];
  };
}
