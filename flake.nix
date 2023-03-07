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
      mkVM = import ./lib/mkvm.nix; 
      user = "cor";
      overlays = [];
    in
    {
      nixosConfigurations = {
        vm-aarch64 = mkVM "vm-aarch64" {
          inherit user inputs overlays nixpkgs home-manager;
          system = "aarch64-linux";
        };

        vm-aarch64-prl = mkVM "vm-aarch64-prl" {
          inherit user inputs overlays nixpkgs home-manager;
          system = "aarch64-linux";
        };

        vm-intel = mkVM "vm-intel" {
          inherit user inputs overlays nixpkgs home-manager;
          system = "x86_64-linux";
        };
      };
      
      darwinConfigurations = {
        default = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [ 
            ./darwin-configuration.nix 
            home-manager.darwinModules.home-manager {
              users.users.cor = {
                name = "cor";
                home = "/Users/cor";
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.cor = import ./home-darwin.nix;
    	        home-manager.extraSpecialArgs = { inherit inputs; };
            }
          ];
          inputs = { inherit darwin nixpkgs inputs; };
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
