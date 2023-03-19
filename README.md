# nixos-config

I use NixOS inside of a Parallels VM on a M1 Mac running macOS. In addition to this, I use Nix to configure macOS with `nix-darwin`.

## Structure


## How to fork this configuration for your own usage

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
12. Open Safari, go to `Settings > Search > Search Engine`. Select **DuckDuckGo**. Go to `Settings > Advanced > Smart Search Field`, click "Show full ewbsite address". Go to `Settings > Advanced`, at the bottom click "Show Develop menu in menu bar"
13. Open Settings.app, Go to `Desktop & Dock > Show recent applications in Dock` and disable it
14. Remove all apps from dock, turn hide dock on

## NixOS VM using Parallels Desktop

1. Install [Parallels Desktop](parallels.com).
2. Download a minimal 64-bit ARM ISO [from the NixOS download page](https://nixos.org/download.html).
3. In parallels: click "Install Windows or another OS from a DVD or image file"
4. Select your `nixos-minimal-...-aarch64-linux.iso`
5. Select "Other Linux"
6. In Name, type "NixOS"
7. Click "Customize settings before installation"
8. Go to "Hardware"
  - CPU & Memory: 
    - Processors: `N - 2` cores where `N` is your core count *(I have 10, so I pick 8)*
    - Memory `N - 8` GB where `N` is your GB count *(I have 32, so I pick 24)*
  - Graphics:
    - Resolution: More Space
    - Advanced > Ensure "Enable 3D acceleration" is enabled.
  - Mouse & Keyboard:
    - Click "Open Shortcuts Preferences" and uncheck all shortcuts.
    - Click "macOS System Shortcuts" in the sidebar, and change "Send macOS system shortcuts" to "always"
  - Shared Printers: uncheck "share mac printers with other linux"
  - Network: Source: Shared Network (Should be selected by default)
  - Hard Disk: Click `Advanced > Properties`. Select Size 256 GB. *(More if you can, but I currently have just 1TB of storage)*
9. Boot the VM, you may have to re-attach the ISO by clicking the CD icon and rebooting.
10. In the VM, type `sudo su`, then `passwd`, and type `root` twice.
11. In the VM, type `ip -brief address` in order to see your VM's IP.
12. On your Mac in this repository, type `export NIXADDR=10.211.55.3` (replace the IP with the IP you found in step 11).
13. On your Mac, in the same shell, type `make vm/bootstrap0` When prompted for the root password, type `root`
14. Your VM will reboot automtaically by this
15. On your Mac, in the same shell, type `make vm/bootstrap`. *(note that there's no 0 at the end this time)*
16. On your Mac, in the same shell, type `make vm/secrets`. 
17. Reboot your VM by typing `reboot`.
18. Log into your VM
19. In `~`, run `git clone git@github.com:cor/nixos-config`
20. Enter your SSH password (stored in 1Password)
21. Run `cd nixos-config && make switch`
22. `reboot`
23. Open `chromium`, go to `chrome://settings/cookies`, and disable "Clear cookies and site data when you close all windows"
24. Go to `chrome://settings/search` and set search engine to "DuckDuckGo"

You now have your VM fully set up! To make changes to the config, just edit the contenst `~/nixos-config`, and run `make switch`

--- 

Config is partially based on https://github.com/mitchellh/nixos-config
