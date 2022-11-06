{
  description = "NixOS systems and tools by cor";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.05";
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

    helix = {
      url = "github:helix-editor/helix";
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
          inherit user inputs nixpkgs home-manager;
          system = "aarch64-linux";

          overlays = [
            (final: prev: {
              # TODO: drop after release following NixOS 22.05
              open-vm-tools = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.open-vm-tools;

              # We need Mesa on aarch64 to be built with "svga". The default Mesa
              # build does not include this: https://github.com/Mesa3D/mesa/blob/49efa73ba11c4cacaed0052b984e1fb884cf7600/meson.build#L192
              mesa = prev.callPackage "${inputs.nixpkgs-unstable}/pkgs/development/libraries/mesa" {
                llvmPackages = final.llvmPackages_latest;
                inherit (final.darwin.apple_sdk.frameworks) OpenGL;
                inherit (final.darwin.apple_sdk.libs) Xplugin;

                galliumDrivers = [
                  # From meson.build
                  "v3d"
                  "vc4"
                  "freedreno"
                  "etnaviv"
                  "nouveau"
                  "tegra"
                  "virgl"
                  "lima"
                  "panfrost"
                  "swrast"

                  # We add this so we get the vmwgfx module
                  "svga"
                ];
              };
            })
          ];
        };

        vm-aarch64-prl = mkVM "vm-aarch64-prl" {
          inherit user inputs overlays nixpkgs home-manager;
          system = "aarch64-linux";
        };

        vm-intel = mkVM "vm-intel" {
          inherit user inputs nixpkgs home-manager overlays;
          system = "x86_64-linux";
        };
      };
      
      darwinConfigurations = {
        default = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [ ./darwin-configuration.nix ];
          inputs = { inherit darwin nixpkgs; };
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
