# This function creates a NixOS system based on our VM setup for a
# particular architecture.
name: { inputs, nixpkgs, home-manager, system, user, darwin }:

darwin.lib.darwinSystem {
  system = "aarch64-darwin";

  # nix-darwin level modules
  modules = [ 
    ./modules/nix.nix
    ./modules/darwin.nix 

    # The home-manager nix-darwin module
    home-manager.darwinModules.home-manager {
      users.users.cor = {
        name = "cor";
        home = "/Users/cor";
      };
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.cor = {
          # Home-manager level modules
          imports = [
            ./home-modules/darwin.nix
            ./home-modules/git.nix
            ./home-modules/gpg.nix
            ./home-modules/zsh.nix
            ./home-modules/kitty.nix
            ./home-modules/helix.nix
            ./home-modules/lazygit.nix
          ];
        };
        # Arguments that are exposed to every `home-module`.
        extraSpecialArgs = {
          pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; config.allowUnfree = true; };
          currentSystemName = name;
          currentSystem = system;
          isDarwin = true;
          inherit inputs;
        };
      };
    }

    # Arguments that are exposed to every `module`.
    {
      config._module.args = {
        currentSystemName = name;
        currentSystem = system;
        pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; config.allowUnfree = true; };
      };
    }    
  ];
  inputs = { inherit darwin nixpkgs inputs; };
}