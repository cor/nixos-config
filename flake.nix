{
  description = "NixOS systems and tools by cor";

  nixConfig = { };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-parallels.url = "github:nixos/nixpkgs?rev=b80cef7eb8a9bc5b4f94172ebf4749c8ee3d770c"; # pinned version of 23.05 because parallels can't handle the newer kernel
    flake-utils.url = "github:numtide/flake-utils";
    to-case.url = "github:cor/ToCase";

    ghostty.url = "git+ssh://git@github.com/mitchellh/ghostty";
    helix.url = "github:helix-editor/helix";
    raspberry-pi-nix.url = "github:tstat/raspberry-pi-nix";

    yazi.url = "github:sxyazi/yazi";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ghostty, to-case, darwin, nixpkgs, nixpkgs-unstable, home-manager, flake-utils, raspberry-pi-nix, ... }@inputs:
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

        raspberry-pi = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            raspberry-pi-nix.nixosModules.raspberry-pi
            ./modules/users.nix
            ./modules/zsh.nix
            ./modules/nix.nix
            ./modules/environment.nix
            ./modules/openssh.nix
            ./modules/system-packages.nix
            ./modules/tailscale.nix
            ./machines/raspberry-pi.nix
            {
              config._module.args = {
                currentSystemName = "raspberry-pi";
                currentSystem = system;
                isDarwin = false;
                pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; config.allowUnfree = true; };
                ghostty = ghostty.packages.${system}.default;
                to-case = to-case.packages.${system}.default;
              };
            }
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.cor = {
                  # Home-manager level modules
                  imports = [
                    { home.stateVersion = "23.11"; }
                    ./home-modules/zsh.nix
                    ./home-modules/lazygit.nix
                    ./home-modules/git.nix
                    ./home-modules/zellij.nix
                    ./home-modules/direnv.nix
                    ./home-modules/helix.nix
                    ./home-modules/yazi.nix
                    ./home-modules/nushell/nushell.nix
                    ./home-modules/zoxide.nix
                    ./home-modules/tmux.nix
                  ];
                };

                extraSpecialArgs = {
                  theme = builtins.readFile ./THEME.txt; # "dark" or "light"
                  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; config.allowUnfree = true; };
                  isDarwin = false;
                  inherit inputs;
                };
              };
            }
          ];
        };


        vm-orb = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./orb/configuration.nix
            ./modules/users.nix
            ./modules/zsh.nix
            ./modules/nix.nix
            ./modules/environment.nix
            ./modules/system-packages.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.cor = {
                  # Home-manager level modules
                  imports = [
                    { home.stateVersion = "23.05"; }
                    # ./home-modules/kitty.nix
                    ./home-modules/zsh.nix
                    ./home-modules/lazygit.nix
                    ./home-modules/git.nix
                    ./home-modules/zellij.nix
                    ./home-modules/direnv.nix
                    ./home-modules/helix.nix
                    ./home-modules/yazi.nix
                    ./home-modules/nushell/nushell.nix
                    ./home-modules/zoxide.nix
                    ./home-modules/tmux.nix
                  ];
                };

                extraSpecialArgs = {
                  theme = builtins.readFile ./THEME.txt; # "dark" or "light"
                  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; config.allowUnfree = true; };
                  isDarwin = false;
                  inherit inputs;
                };
              };
            }
            {
              config._module.args = {
                currentSystemName = "vm-orb";
                currentSystem = system;
                isDarwin = system == "aarch64-darwin";
                pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; config.allowUnfree = true; };
                ghostty = ghostty.packages.${system}.default;
                to-case = to-case.packages.${system}.default;
              };
            }
          ];
        };
      };

      darwinConfigurations = let system = "aarch64-darwin"; in {
        default = mkDarwin "vm-aarch64-vmware" {
          inherit user inputs nixpkgs home-manager system darwin;
        };
      };

    } // (flake-utils.lib.eachDefaultSystem (system:
      let pkgs-unstable = import nixpkgs-unstable { inherit system; }; in
      {
        formatter = pkgs-unstable.nixpkgs-fmt;

        devShells = {
          default = pkgs-unstable.mkShell {
            buildInputs = with pkgs-unstable; [ nixd nil nixpkgs-fmt sumneko-lua-language-server cmake-language-server ];
          };
        };
      }
    ));
}
