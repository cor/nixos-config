{ pkgs-unstable, ... }:
{
  programs.nushell = {
    package = pkgs-unstable.nushell;
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
  };
}
