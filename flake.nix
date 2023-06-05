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
