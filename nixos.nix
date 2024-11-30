# This function creates a NixOS system based on our VM setup for a
# particular architecture.
name: {  inputs, nixpkgs, home-manager, system, user, isHeadless }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; config.allowUnfree = true; };
in
nixpkgs.lib.nixosSystem rec {
  inherit system;

  # NixOS level modules
  modules = [
    # inputs.union.nixosModules.hubble
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi
    ./hardware/${name}.nix
    ./machines/${name}.nix

    ./modules/users.nix
    ./modules/zsh.nix
    ./modules/nix.nix
    ./modules/environment.nix
    ./modules/system-packages.nix
    ./modules/docker.nix
    ./modules/code-server.nix
    ./modules/tailscale.nix
    # ./modules/nginx.nix
    # ./modules/caddy.nix


    # if not headless
    # ./modules/fonts.nix
    # ./modules/misc.nix
    # ./modules/openssh.nix
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
            { home.stateVersion = "24.05"; }
            # ./home-modules/kitty.nix
            ./home-modules/bat.nix
            ./home-modules/direnv.nix
            ./home-modules/git.nix
            ./home-modules/helix.nix
            # ./home-modules/emacs.nix
            ./home-modules/lazygit.nix
            # ./home-modules/nushell/nushell.nix
            ./home-modules/tmux.nix
            ./home-modules/yazi.nix
            ./home-modules/zellij.nix
            ./home-modules/zoxide.nix
            ./home-modules/zsh.nix


            # if not headless
            # ./home-modules/awesome.nix
            # ./home-modules/chromium.nix
            # ./home-modules/flameshot.nix
            # ./home-modules/nixos-misc.nix
            # ./home-modules/rofi.nix
          ];
        };
        # Arguments that are exposed to every `home-module`.
        extraSpecialArgs = {
          theme = builtins.readFile ./THEME.txt; # "dark" or "light"
          inherit pkgs-unstable inputs user;
          currentSystemName = name;
          currentSystem = system;
          isDarwin = false;
        };
      };
    }

    {
      config._module.args = {
        currentSystemName = name;
        currentSystem = system;
        isDarwin = system == "aarch64-linux";
        inherit pkgs-unstable user;
        pkgs-caddy = import inputs.nixpkgs-caddy { inherit system; };
        # ghostty = inputs.ghostty.packages.${system}.default;
        ucode = inputs.union-tools.packages.${system}.ucode;
      };
    }
  ];
}
