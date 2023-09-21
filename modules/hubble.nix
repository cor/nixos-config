{ inputs, pkgs, pkgs-unstable, lib, currentSystemName, ... }:
{
  services.hubble = {
    enable = true;
    url = "https://noble-pika-27.hasura.app/v1/graphql";
    hasura-admin-secret = "3N5Mt2f4Y1AC7dE663AsGqRy66yiHBuZ3RMgUjM6X4Q3Ma8G2yKmVoasdasdsadasda";
    indexers = [
      { url = "https://rpc.0xc0dejug.uno/"; type = "tendermint"; }
    ];
  };
}

