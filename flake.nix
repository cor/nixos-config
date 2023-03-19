{
  description = "NixOS systems and tools by cor";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils = { url = "github:numtide/flake-utils"; };
    helix.url = "github:helix-editor/helix";
    
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, darwin, nixpkgs, home-manager, flake-utils, ... }@inputs:
    let 
      mkNixos = import ./nixos.nix; 
      mkDarwin = import ./darwin.nix;
      user = "cor";
    in
    {
      nixosConfigurations = let system = "aarch64-linux"; in {
        vm-aarch64-parallels = mkNixos "vm-aarch64-parallels" {
          inherit user inputs nixpkgs home-manager system;
        };

        vm-aarch64-vmware = mkNixos "vm-aarch64-vmware" {
          inherit user inputs nixpkgs home-manager system;
        };
      };
      
      darwinConfigurations = let system = "aarch64-darwin"; in {
        default = mkDarwin "vm-aarch64-vmware" {
          inherit user inputs nixpkgs home-manager system darwin;
        };
      };
      
    } // (flake-utils.lib.eachSystem (with flake-utils.lib; [system.x86_64-linux system.aarch64-linux ]) (system:
      let pkgs = import nixpkgs { inherit system; }; in
      {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [ nil sumneko-lua-language-server cmake-language-server];
          };
        };
      }
    ));
}
