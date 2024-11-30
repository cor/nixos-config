{ network, config, pkgs, pkgs-unstable, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults = { email = "cor@pruijs.dev"; };
  };
  services.nginx =
    let
      redirect = port: {
        forceSSL = true;
        sslCertificate = ../ca/nginx-selfsigned.crt;
        sslCertificateKey = ../ca/SECRET.key;

        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:${toString port}";
            proxyWebsockets = true;
          };
        };
        extraConfig = ''
          add_header Access-Control-Allow-Origin *;
          add_header Access-Control-Max-Age 3600;
          add_header Access-Control-Expose-Headers Content-Length;
        '';
      };

      redirectGrpc = port: {
        forceSSL = true;
        sslCertificate = ../ca/nginx-selfsigned.crt;
        sslCertificateKey = config.sops.secrets."nginx/nginx-selfsigned.key".path;

        locations = {
          "/" = {
            extraConfig = ''
              grpc_pass grpc://127.0.0.1:${toString port};
              grpc_read_timeout      600;
              grpc_send_timeout      600;
              proxy_connect_timeout  600;
              proxy_send_timeout     600;
              proxy_read_timeout     600;
              send_timeout           600;
              proxy_request_buffering off;
              proxy_buffering off;
            '';
          };
        };
        extraConfig = ''
          add_header Access-Control-Allow-Origin *;
          add_header Access-Control-Max-Age 3600;
          add_header Access-Control-Expose-Headers Content-Length;
        '';
      };
    in
    {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts = {
        "code.corbook-nixos.cor.systems" = redirect 42042;
        # "rest.${network}.cor.systems" = redirect 1317;
        # "grpc.${network}.cor.systems" = redirectGrpc 9090;
      };
    };
}
