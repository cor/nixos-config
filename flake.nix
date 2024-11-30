{
  description = "NixOS systems and tools by cor";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    union-tools.url = "github:unionlabs/tools";

    # Used for caddy plugins
    nixpkgs-caddy.url = "github:jpds/nixpkgs/caddy-external-plugins";

    helix.url = "github:helix-editor/helix";
    yazi.url = "github:sxyazi/yazi";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    ghostty.url = "git+ssh://git@github.com/ghostty-org/ghostty";

    flake-utils.url = "github:numtide/flake-utils";
    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix/v0.4.1";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ghostty, union-tools, darwin, nixpkgs, nixpkgs-unstable, home-manager, flake-utils, raspberry-pi-nix, ... }@inputs:
    let
      mkNixos = import ./nixos.nix;
      mkDarwin = import ./darwin.nix;
      user = {
        name = "cor";
        githubName = "cor";
        email = "cor@pruijs.dev";
        hashedPassword = "$6$sb3eB/EbsWnfAqzy$szu0h/hbX9/23n5RKE0dwzV8lmq.1Yj2NzI/jYQxJZIbzmY8dpIYRdhUVZgCMnR0CeqrQfgzs6FtPoGUiCqDR0";
        codeHashedPassword = "$argon2i$v=19$m=4096,t=3,p=1$EhoOotFaUezZdQ+6Nfaz6w$ba74RTp6245H0K0URZmDsV1GBmVSHwzF5BT42FA9Y3I";
        sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAN0JRbnTsz4eEUeL6My/ew+rX3Qojawn+Y1B3buPuyC";
      };
    in
    {
      nixosConfigurations = {
        corbookpro-nixos = mkNixos {
          inherit inputs nixpkgs home-manager user;
          machine = {
            name = "corbookpro-nixos";
            system = "aarch64-linux";
            darwin = false;
            headless = true;
            stateVersion = "24.05";
            homeStateVersion = "24.05";
          };
        };

        corbookair-nixos = mkNixos {
          inherit inputs nixpkgs home-manager user;
          machine = {
            name = "corbookair-nixos";
            system = "aarch64-linux";
            darwin = false;
            headless = true;
            stateVersion = "24.05";
            homeStateVersion = "24.05";
          };
        };

        raspberry-pi = mkNixos {
          inherit inputs nixpkgs home-manager user;
          machine = {
            name = "raspberry-pi";
            system = "aarch64-linux";
            darwin = false;
            headless = true;
            stateVersion = "23.11";
            homeStateVersion = "24.05";
          };
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
