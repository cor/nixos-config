{ pkgs-unstable, ...}:
{
  nix = {
    package = pkgs-unstable.nix;
    settings = {
      sandbox = "relaxed";
      substituters = [ 
        "https://nix-community.cachix.org/" 
        "https://mitchellh-nixos-config.cachix.org" 
        "https://helix.cachix.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "mitchellh-nixos-config.cachix.org-1:bjEbXJyLrL1HZZHBbO4QALnI5faYZppzkU4D2s0G8RQ="    
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      ];  
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };
}