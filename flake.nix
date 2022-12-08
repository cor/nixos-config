{
  description = "NixOS systems and tools by cor";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.11";
    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Locks nixpkgs to an older version with an older Kernel that boots
    # on VMware Fusion Tech Preview. This can be swapped to nixpkgs when
    # the TP fixes the bug.
    nixpkgs-old-kernel.url = "github:nixos/nixpkgs/bacbfd713b4781a4a82c1f390f8fe21ae3b8b95b";

    flake-utils = { url = "github:numtide/flake-utils"; };
    
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix.url = "github:helix-editor/helix";
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
            buildInputs = with pkgs; [ rnix-lsp sumneko-lua-language-server cmake-language-server];
          };
        };
      }
    ));
}
