{ user, pkgs-caddy, ... }:
{
  services.caddy = {
    enable = true;
    package = pkgs-caddy.caddy.override {
      externalPlugins = [
        {
          name = "cloudflare";
          repo = "github.com/caddy-dns/cloudflare";
          version = "master";
        }
      ];
      vendorHash = "sha256-YRsPu+rTu9HEQQlj4dK2BH8DNGHo//VL5zhoU0hz7DI=";
    };
    email = user.email;
    configFile = ./caddy_config;
  };
}
