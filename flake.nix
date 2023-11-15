{
  description = "NixOS systems and tools by cor";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/release-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-parallels.url = "github:nixos/nixpkgs?rev=b80cef7eb8a9bc5b4f94172ebf4749c8ee3d770c"; # pinned version of 23.05 because parallels can't handle the newer kernel
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
    rec
    {
      packages.aarch64-linux = let pkgs = import nixpkgs { system = "aarch64-linux"; }; in {

        set-theme = pkgs.writeShellApplication {
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
        current-task = pkgs.writeShellApplication {
          name = "current-task";
          text = ''
             NEWEST_ENTRY=$(find /home/cor/omega/Journal/*.* | tac | head -n 1)
            	CURRENT_TASK=$(grep --color=never -e '- \[ \]' < "$NEWEST_ENTRY" | head -n 1 | awk '{$1=$1};1' | cut -c 7-)
               echo "$CURRENT_TASK"
          '';
        };

        xset-r-fast = pkgs.writeShellScriptBin "xset-r-fast" ''
          xset r rate 150 40
        '';

        xset-r-slow = pkgs.writeShellScriptBin "xset-r-slow" ''
          xset r rate 350 20
        '';
      };


      nixosConfigurations = let system = "aarch64-linux"; in {
        vm-aarch64-parallels = mkNixos "vm-aarch64-parallels" {
          inherit user inputs home-manager system;
          nixpkgs = inputs.nixpkgs-parallels;
          custom-packages = packages.aarch64-linux;
        };

        vm-aarch64-utm = mkNixos "vm-aarch64-utm" {
          inherit user inputs nixpkgs home-manager system;
          custom-packages = packages.aarch64-linux;
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
        formatter = pkgs.nixpkgs-fmt;

        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [ nil nixpkgs-fmt sumneko-lua-language-server cmake-language-server ];
          };
        };
      }
    ));
}
