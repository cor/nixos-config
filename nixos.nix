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
  modules =
    (if machine.headless then [
    ] else [
      {
        nixpkgs.overlays = [ inputs.niri.overlays.niri ];
        imports = [
          inputs.niri.nixosModules.niri
          inputs.stylix.nixosModules.stylix
        ];
      }
      ./modules/niri.nix
      ./modules/fonts.nix
      ./modules/stylix.nix
      ./modules/networking.nix

      # todo: make generic over hardware
      # inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
    ]) ++
    [
      ./hardware/${machine.name}.nix
      ./machines/${machine.name}.nix
      ./modules/users.nix
      ./modules/zsh.nix
      ./modules/nix.nix
      ./modules/environment.nix
      ./modules/system-packages.nix
      ./modules/docker.nix
      ./modules/tailscale.nix
      # ./modules/code-server.nix
      # ./modules/caddy.nix

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
              ./home-modules/direnv.nix
              ./home-modules/git.nix
              ./home-modules/helix.nix
              ./home-modules/lazygit.nix
              ./home-modules/tmux.nix
              ./home-modules/yazi.nix
              ./home-modules/zellij.nix
              ./home-modules/zoxide.nix
              ./home-modules/zsh.nix
              ./home-modules/ghostty.nix
              # ./home-modules/emacs.nix
              # ./home-modules/nushell/nushell.nix
            ] ++ (if machine.headless then [
            ] else [
              ./home-modules/waybar.nix
              ./home-modules/niri.nix
              ./home-modules/fuzzel.nix
              ./home-modules/swaylock.nix
              ./home-modules/zed.nix
            ]);
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
    ] ++ nixpkgs.lib.optionals (machine.name == "raspberry-pi") [
      inputs.raspberry-pi-nix.nixosModules.raspberry-pi
    ];
}
