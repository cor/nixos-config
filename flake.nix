{
  description = "NixOS systems and tools by cor";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?rev=b80cef7eb8a9bc5b4f94172ebf4749c8ee3d770c"; # pinned version of 23.05 because parallels can't handle the newer kernel
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # The SSH kitten broke with the latest kitty release.
    # will use this rev until fixed
    nixpkgs-kitty.url = "github:nixos/nixpkgs/65702964b39bcf6d5c6b5b898b7d73e08b94b13f";
    flake-utils.url = "github:numtide/flake-utils";
    helix.url = "github:helix-editor/helix";
    
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
    url = "github:nix-community/home-manager/release-23.05";
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
      packages.aarch64-linux.set-theme = let 
        pkgs = import nixpkgs { system = "aarch64-linux";}; 
        in pkgs.writeShellApplication {
          name = "switch-theme";
          runtimeInputs = with pkgs; [ coreutils nixos-rebuild ];
          text = ''
            if [ "$1" != "light" ] && [ "$1" != "dark" ]; then
              echo "Error: Theme must be 'light' or 'dark'"
              exit 1
            fi
            
            echo "$1"
            cd /home/cor/nixos-config
            printf '%s' "$1" > THEME.txt
            sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch --flake ".#vm-aarch64-parallels"
          '';
      };
    
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
      
    } // (flake-utils.lib.eachDefaultSystem (system:
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
