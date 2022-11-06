# New Mac

*Make sure not to install **Homebrew** or **Xcode Command Line Tools**!*

1. Install macOS, deny analytics.
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