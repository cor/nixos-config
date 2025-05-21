{
  description = "NixOS systems and tools by cor";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    open-project.url = "github:cor/open-project";
    gh-permalink.url = "github:cor/gh-permalink";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    union-tools.url = "github:unionlabs/tools";

    # Used for caddy plugins
    nixpkgs-caddy.url = "github:jpds/nixpkgs/caddy-external-plugins";

    helix.url = "github:helix-editor/helix";
    yazi.url = "github:sxyazi/yazi";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    ghostty.url = "github:ghostty-org/ghostty";

    flake-utils.url = "github:numtide/flake-utils";
    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix/v0.4.1";
    niri.url = "github:sodiboo/niri-flake";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix/release-24.11";
  };

  outputs = { self, union-tools, darwin, nixpkgs, nixpkgs-unstable, nixos-hardware, home-manager, flake-utils, raspberry-pi-nix, ... }@inputs:
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

      corworkUser = user // {
        hashedPassword = "$6$8w3GvquMlrc0rbZX$85TiiuiouAgD5jbU9qtnI7HUy7GfOJ.aKm3/Jyne0QrvEPB7FUXXhe.J6rqAzIWcuxMu3uJUV1VbzTlTJxjUx1";
      };
    in
    {
      nixosConfigurations = {
        corwork = mkNixos {
          inherit inputs nixpkgs home-manager;
          user = corworkUser;
          machine = {
            domain = "corwork.cor.systems";
            name = "corwork";
            system = "x86_64-linux";
            darwin = false;
            headless = false;
            stateVersion = "24.11";
            homeStateVersion = "24.11";
          };
        };

        corbookpro-nixos = mkNixos {
          inherit inputs nixpkgs home-manager user;
          machine = {
            domain = "corbookpro-nixos.cor.systems";
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
            domain = "corbookair-nixos.cor.systems";
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
            domain = "raspberry-pi.cor.systems";
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
      let
        pkgs-unstable = import nixpkgs-unstable { inherit system; };
        basePackages = {
          formatter = pkgs-unstable.nixpkgs-fmt;
        };
        darwinPackages = pkgs-unstable.lib.optionalAttrs (system == "aarch64-darwin") {
          move-default = pkgs-unstable.writeShellApplication {
            name = "move-default";
            text = ''
              echo "moving default macOS config files if they exist"
              [ ! -f /etc/zshenv ] || sudo mv /etc/zshenv /etc/zshenv.bak
              [ ! -f /etc/zshrc ] || sudo mv /etc/zshrc /etc/zshrc.bak
              [ ! -f /etc/bashrc ] || sudo mv /etc/bashrc /etc/bashrc.bak
            '';
          };
          switch = pkgs-unstable.writeShellApplication {
            name = "switch";
            runtimeInputs = [
              pkgs-unstable.nix
              inputs.darwin.packages.${system}.darwin-rebuild
            ];
            text = ''
              darwin-rebuild switch --flake ".#''${NIXNAME:-$(hostname)}"
            '';
          };
        };
        linuxPackages = pkgs-unstable.lib.optionalAttrs (system == "aarch64-linux" || system == "x86_64-linux") rec {
          default = switch;
          switch = pkgs-unstable.writeShellApplication {
            name = "switch";
            runtimeInputs = [ pkgs-unstable.nix ];
            text = ''
              sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch --flake ".#''${NIXNAME:-$(hostname)}"
            '';
          };
          switch-networking = pkgs-unstable.writeShellApplication {
            name = "switch";
            runtimeInputs = [ pkgs-unstable.nix ];
            text = ''
              sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch --flake ".#''${NIXNAME:-$(hostname)}"
              sudo systemctl restart NetworkManager
            '';
          };
          switch-show-trace = pkgs-unstable.writeShellApplication {
            name = "switch-show-trace";
            runtimeInputs = [ pkgs-unstable.nix ];
            text = ''
              sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch --flake ".#''${NIXNAME:-$(hostname)}" --show-trace
            '';
          };
          theme-switch = pkgs-unstable.writeShellApplication {
            name = "theme-switch";
            runtimeInputs = [ ];
            text = ''
              if [ "$#" -ne 1 ]; then
                echo "Usage: theme-switch [light|dark]"
                exit 1
              fi

              MODE="$1"
              
              if [ "$MODE" = "dark" ]; then
                sudo nixos-rebuild switch --flake /home/cor/dev/cor/nixos-config#corwork
                systemctl --user restart swaybg.service
                systemctl --user restart waybar.service
                echo "Switched to dark mode and restarted swaybg and waybar."
                echo "To reload Ghostty configuration, press Ctrl+Shift+, in each Ghostty window"
              elif [ "$MODE" = "light" ]; then
                sudo nixos-rebuild switch --flake /home/cor/dev/cor/nixos-config#corwork --specialisation light
                systemctl --user restart swaybg.service
                systemctl --user restart waybar.service
                echo "Switched to light mode and restarted swaybg and waybar."
                echo "To reload Ghostty configuration, press Ctrl+Shift+, in each Ghostty window"
              else
                echo "Error: Invalid mode. Use 'light' or 'dark'."
                exit 1
              fi
            '';
          };
          
          keyboard-brightness = pkgs-unstable.writeShellApplication {
            name = "keyboard-brightness";
            runtimeInputs = [ pkgs-unstable.sudo ];
            text = ''
              #!/usr/bin/env bash

              KB_BACKLIGHT="/sys/class/leds/chromeos::kbd_backlight/brightness"
              MAX_BRIGHTNESS=100

              usage() {
                echo "Usage: keyboard-brightness [get|set VALUE|up|down|max|off]"
                echo ""
                echo "Controls keyboard backlight brightness"
                echo ""
                echo "Commands:"
                echo "  get       - Display current brightness (0-$MAX_BRIGHTNESS)"
                echo "  set VALUE - Set brightness to VALUE (0-$MAX_BRIGHTNESS)"
                echo "  up        - Increase brightness by 10"
                echo "  down      - Decrease brightness by 10"
                echo "  max       - Set brightness to maximum"
                echo "  off       - Turn off keyboard backlight"
                exit 1
              }

              # Check if the kbd backlight sysfs path exists
              if [ ! -f "$KB_BACKLIGHT" ]; then
                echo "Error: Keyboard backlight control not available at $KB_BACKLIGHT"
                exit 1
              fi

              # Check if we have sudo access for writing
              check_sudo() {
                if [ "$EUID" -ne 0 ]; then
                  echo "This operation requires sudo access"
                  exit 1
                fi
              }

              get_brightness() {
                cat "$KB_BACKLIGHT"
              }

              set_brightness() {
                local value=$1
                
                # Ensure the value is within range
                if [ "$value" -lt 0 ]; then
                  value=0
                elif [ "$value" -gt "$MAX_BRIGHTNESS" ]; then
                  value="$MAX_BRIGHTNESS"
                fi
                
                # Write the new value
                echo "$value" | sudo tee "$KB_BACKLIGHT" > /dev/null
                echo "Keyboard brightness set to $value"
              }

              # Process command line arguments
              if [ $# -eq 0 ]; then
                usage
              fi

              case "$1" in
                get)
                  get_brightness
                  ;;
                set)
                  if [ $# -ne 2 ] || ! [[ "$2" =~ ^[0-9]+$ ]]; then
                    echo "Error: 'set' requires a numeric brightness value (0-$MAX_BRIGHTNESS)"
                    usage
                  fi
                  check_sudo
                  set_brightness "$2"
                  ;;
                up)
                  current=$(get_brightness)
                  new=$((current + 10))
                  check_sudo
                  set_brightness "$new"
                  ;;
                down)
                  current=$(get_brightness)
                  new=$((current - 10))
                  check_sudo
                  set_brightness "$new"
                  ;;
                max)
                  check_sudo
                  set_brightness "$MAX_BRIGHTNESS"
                  ;;
                off)
                  check_sudo
                  set_brightness 0
                  ;;
                *)
                  usage
                  ;;
              esac

              exit 0
            '';
          };
        };
      in
      {
        packages = basePackages // darwinPackages // linuxPackages;

        apps = pkgs-unstable.lib.optionalAttrs (system == "aarch64-linux" || system == "x86_64-linux") {
          theme-switch = {
            type = "app";
            program = "${self.packages.${system}.theme-switch}/bin/theme-switch";
          };
        };

        devShells = {
          default = pkgs-unstable.mkShell {
            buildInputs = with pkgs-unstable; [
              nixd
              nil
              nixpkgs-fmt
              sumneko-lua-language-server
              cmake-language-server
              self.packages.${system}.switch
              self.packages.${system}.switch-show-trace
              self.packages.${system}.theme-switch
            ];
          };
        };
      }
    ));
}
