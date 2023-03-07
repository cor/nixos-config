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
    ../modules/xrandr.nix
    ../modules/openssh.nix
    home-manager.nixosModules.home-manager {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.cor = {
          home.stateVersion = "23.05";
          xdg.enable = true;
          xresources.properties = let dpi = 192; in {
            "Xft.dpi" = dpi;
            "*.dpi" = dpi;
          };
          imports = [
            ../home-modules/awesome.nix
            ../home-modules/chromium.nix
            ../home-modules/flameshot.nix
            ../home-modules/git.nix
            ../home-modules/gpg.nix
            ../home-modules/helix.nix
            ../home-modules/kitty.nix
            ../home-modules/lazygit.nix
            ../home-modules/ranger.nix
            ../home-modules/rofi.nix
            ../home-modules/tmux.nix
            ../home-modules/zsh.nix
            ../home-modules/gtk.nix
            ../home-modules/packages.nix
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
