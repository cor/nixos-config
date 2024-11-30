{
  description = "NixOS systems and tools by cor";

  nixConfig = { };

  inputs = {
    union-tools.url = "github:unionlabs/tools";
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Used for caddy plugins
    nixpkgs-caddy.url = "github:jpds/nixpkgs/caddy-external-plugins";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    flake-utils.url = "github:numtide/flake-utils";
    to-case.url = "github:cor/ToCase";
    raspberry-pi-nix.url = "github:tstat/raspberry-pi-nix";
    helix.url = "github:helix-editor/helix";
    yazi.url = "github:sxyazi/yazi";
    ghostty.url = "git+ssh://git@github.com/ghostty-org/ghostty";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ghostty, union-tools, to-case, darwin, nixpkgs, nixpkgs-unstable, home-manager, flake-utils, raspberry-pi-nix, ... }@inputs:
    let
      mkNixos = import ./nixos.nix;
      mkDarwin = import ./darwin.nix;
      user = "cor";
    in
    {
      nixosConfigurations = let system = "aarch64-linux"; in {
        corbookpro-nixos = mkNixos "corbookpro-nixos" {
          inherit user inputs nixpkgs home-manager system;
          isHeadless = true;
          custom-packages = { };
        };

        # TODO: Unify with mkNixos
        raspberry-pi = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            raspberry-pi-nix.nixosModules.raspberry-pi
            ./machines/raspberry-pi.nix
            ./modules/users.nix
            ./modules/zsh.nix
            ./modules/nix.nix
            ./modules/environment.nix
            ./modules/openssh.nix
            ./modules/system-packages.nix
            ./modules/tailscale.nix
            ./modules/caddy.nix
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
      };

      darwinConfigurations = let system = "aarch64-darwin"; in {
        default = mkDarwin "CorBook-Darwin" {
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
