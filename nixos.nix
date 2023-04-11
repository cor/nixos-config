# This function creates a NixOS system based on our VM setup for a
# particular architecture.
name: {inputs, nixpkgs, home-manager, system, user  }:

nixpkgs.lib.nixosSystem rec {
  inherit system;

  # NixOS level modules
  modules = [
    ./hardware/${name}.nix
    ./machines/${name}.nix
    ./modules/nixpkgs.nix
    ./modules/misc.nix
    ./modules/environment.nix
    ./modules/fonts.nix
    ./modules/networking.nix
    ./modules/nix.nix
    ./modules/users.nix
    ./modules/xserver.nix
    ./modules/xrandr.nix
    ./modules/openssh.nix
    ./modules/zsh.nix

    # The home-manager NixOS module
    home-manager.nixosModules.home-manager {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.cor = {
          # Home-manager level modules
          imports = [
            ./home-modules/bat.nix
            ./home-modules/nixos-misc.nix
            ./home-modules/awesome.nix
            ./home-modules/chromium.nix
            ./home-modules/direnv.nix
            ./home-modules/flameshot.nix
            ./home-modules/git.nix
            ./home-modules/gpg.nix
            ./home-modules/helix.nix
            ./home-modules/kitty.nix
            ./home-modules/lazygit.nix
            ./home-modules/ranger.nix
            ./home-modules/rofi.nix
            ./home-modules/tmux.nix
            ./home-modules/zsh.nix
            ./home-modules/gtk.nix
            ./home-modules/packages.nix
          ];
        };
        # Arguments that are exposed to every `home-module`.
        extraSpecialArgs = {
          pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; config.allowUnfree = true; };
          currentSystemName = name;
          currentSystem = system;
          theme = "dark"; # "dark" or "light"
          isDarwin = false;
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
}
