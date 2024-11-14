# nixos-config

My [NixOS](https://nixos.org), [nix-darwin](http://daiderd.com/nix-darwin/) and [Home Manager](https://github.com/nix-community/home-manager) configurations.

## Structure

I use NixOS inside of a OrbStack on a M3 Mac running macOS. In addition to this, I use nix-darwin to configure macOS with `nix-darwin`. Both of these setups also use Home Manager. These configurations share the same `modules/` and `home-modules/`. The `nixosConfigurations` call into the `mkNixos` function defined in `nixos.nix`. The `darwinConfigurations` call into the `mkDarwin` function defined in `darwin.nix`.


### Modules

There are two kinds of modules:

1. `modules/`, which define **NixOS** or **nix-darwin** level options.
2. `home-modules/`, which define **Home Manager** options on both NixOS and macOS.

### Configuration generating functions

The modules mentioned above are imported inside of two configuration generation functions:

1. `./nixos.nix`, this function generates a `nixosConfiguration`
2. `./darwin.nix`, this function generates a `darwinConfiguration`



These fucntions are used in `./flake.nix`'s `nixosConfigurations` and `darwinConfigurations` 


## How to fork this configuration for your own usage

_NOTE: These instructions are out of date_

1. Do a project-wide search of my username, `cor` and replace it with `your_username`. Be careful not to replace things that are not my username, such as "core".
2. In `./nixos.nix`, replace the value of `hashedPassword` with one you've generated with `mkpasswd -m sha-512` [See here for more info](https://search.nixos.org/options?channel=22.05&show=users.users.%3Cname%3E.hashedPassword&from=0&size=50&sort=relevance&type=packages&query=users.users.%3Cname%3E.hash).
3. In `./programs/git.nix`, change `userName` and `extraConfig.github.user` to your GitHub username. Also change `signing.key` to the public GPG key you use for your GitHub account.

## macOS Nix config with `nix-darwin`

*NOTE: macOS Nix config is not required for setting up the NixOS VM. For instructions on this, check the next section*

*Make sure not to install **Homebrew** or **Xcode Command Line Tools**!*

1. Do a clean install macOS, deny analytics.
2. Install `Nix` on macOS with [the installer](https://nixos.org/download.html#nix-install-macos)
3. In ~, execute `nix-shell -p git --command "git clone https://github.com/cor/nixos-config"`
4. Install `nix-darwin` with [the nix-darwin installer](https://github.com/LnL7/nix-darwin).
5. Restart **Terminal.app**
6. `sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.original`
7. In `~/nixos-config`, execute `nix-shell --no-sandbox -p cmake --command "make switch-darwin"`
8. [Download 1Password](https://1password.com/download) and browser extension
9. From 1Password, download SSH keys: `id_ed25519` and `id_ed25519.pub`. Move them to `~/.ssh~`
10. From 1Password, download GPG keys: `secret-key-backup.asc`. Import them with: `gpg --import ./secret-key-backup.asc`. Afterwards, run `rm ./secret-key-backup.asc`
11. From 1Password, download GPG `trust-db-backup.txt`. Import them with: `gpg --import-ownertrust < ./trustdb-backup.txt`, Afterwards, run `rm ./trustdb-backup.txt`

### Native apps to install

- OrbStack
- Ghostty
- Tailscale
- 1Password

- Brave
- Firefox

- Signal
- Telegram
- ElementX

- Portal
- reMarkable
- World Clock

- Balance Lock
- Vivid
- Hidden Bar
- Advanced Screen Share

- Gifski
- Photomator
- Pixelmator
- Final Cut Pro

- AeroSpace
- Lasso


### macOS config

1. Change Screenshots folder and file format
2. Disable "automatically re-arrange spaces"
3. Disable auto brightness and true tone
4. Set capslock to control
5. disable recent apps in dock
6. add screenshots folder to dock
7. sign in to email accounts
8. set safari search engine to duck duck go
9. enable safari develop menu
10. disable autocorrect everywhere
11. enable downloading full photos library in photos app


## Raspberry Pi setup

To bootstrap the SD card:

1. Enter orbstack
2. `nix build '.#nixosConfigurations.raspberry-pi.config.system.build.sdImage'`
3. `cp ./result/sd-image/nixos-...-linux.img.zst /Users/cor/Desktop`
4. On macOS, download [rpi-imager](https://www.raspberrypi.com/software/)
5. Insert SD card into MacBook
6. Flash the `.img.zst` from your Desktop to the rPi's sd card. 
7. Insert sd card into raspberry pi and click the power button

Your Raspberry Pi should now be bootstrapped and you should be able to SSH into it.

To udpate the pi from the pi itself

1. clone this repo on the pi
2. `sudo nixos-rebuild switch --flake .#raspberry-pi`

--- 

Config is partially based on https://github.com/mitchellh/nixos-config
