# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{ inputs, nixpkgs, home-manager, user, machine }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = machine.system; config.allowUnfree = true; };
  pkgs-caddy = import inputs.nixpkgs-caddy { system = machine.system; };
in
nixpkgs.lib.nixosSystem rec {
  system = machine.system;

  # NixOS level modules
  modules = [
    # inputs.union.nixosModules.hubble
    # ./hardware/${machine.name}.nix
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi
    ./machines/${machine.name}.nix

    ./modules/users.nix
    ./modules/zsh.nix
    ./modules/nix.nix
    ./modules/environment.nix
    ./modules/system-packages.nix
    ./modules/docker.nix
    ./modules/code-server.nix
    ./modules/tailscale.nix
    # ./modules/caddy.nix


    # if not headless
    # ./modules/fonts.nix
    # ./modules/misc.nix
    # ./modules/opensshix
    # ./modules/thunar.nix
    # ./modules/xrandr.nix
    # ./modules/xserver.nix
    # 

    # The home-manager NixOS module
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        users.${user.name} = {
          # Home-manager level modules
          imports = [
            { home.stateVersion = machine.homeStateVersion; }
            ./home-modules/bat.nix
            ./home-modules/direnv.nix
            ./home-modules/git.nix
            ./home-modules/helix.nix
            ./home-modules/lazygit.nix
            ./home-modules/tmux.nix
            ./home-modules/yazi.nix
            ./home-modules/zellij.nix
            ./home-modules/zoxide.nix
            ./home-modules/zsh.nix
            # ./home-modules/emacs.nix
            # ./home-modules/nushell/nushell.nix


            # if not headless
            # ./home-modules/awesome.nix
            # ./home-modules/chromium.nix
            # ./home-modules/flameshot.nix
            # ./home-modules/rofi.nix
          ];
        };
        # Arguments that are exposed to every `home-module`.
        extraSpecialArgs = {
          theme = builtins.readFile ./THEME.txt; # "dark" or "light"
          inherit inputs pkgs-unstable user machine;
        };
      };
    }

    {
      config._module.args = {
        inherit inputs pkgs-unstable user machine pkgs-caddy;
      };
    }
  ];
}
