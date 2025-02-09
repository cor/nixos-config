{ user, machine, pkgs, pkgs-caddy, ... }:
let
  # TODO: sops
  CF_API_KEY = builtins.readFile ./CF_API_KEY;
in
{
  services.caddy = {
    enable = false;
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
    configFile = pkgs.writeText "caddy_config" ''
      (cloudflare) {
        tls {
          dns cloudflare ${CF_API_KEY}
        }
      }

      code.${machine.domain} {
        reverse_proxy http://0.0.0.0:42042
        import cloudflare
      }
    '';
  };
}
