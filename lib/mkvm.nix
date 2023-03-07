# This function creates a NixOS system based on our VM setup for a
# particular architecture.
name: {inputs, nixpkgs, home-manager, system, user  }:

nixpkgs.lib.nixosSystem rec {
  inherit system;

  modules = [
    ../hardware/${name}.nix
    ../machines/${name}.nix
    ../modules/nixpkgs.nix
    ../modules/misc.nix
    ../modules/environment.nix
    ../modules/fonts.nix
    ../modules/networking.nix
    ../modules/nix.nix
    ../modules/users.nix
    ../modules/xserver.nix
    ../modules/openssh.nix
    home-manager.nixosModules.home-manager {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.cor = {
          imports = [
            ../home-nixos.nix
            ../home-modules/kitty.nix
          ];
        };
        extraSpecialArgs = {
          pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; config.allowUnfree = true; };
          currentSystemName = name;
          currentSystem = system;
          isDarwin = (system == "aarch64-darwin" || system == "x86_64-darwin");
          inherit inputs;
        };
      };
    }

    # We expose some extra arguments so that our modules can parameterize
    # better based on these values.
    {
      config._module.args = {
        currentSystemName = name;
        currentSystem = system;
        pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; config.allowUnfree = true; };
      };
    }
  ];
}
