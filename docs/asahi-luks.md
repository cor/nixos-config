SOURCE: https://github.com/vilvo/mxdots/blob/main/README.md

---

Archived because dotfiles of apple-silicon hosts are merged to https://github.com/vilvo/dotfiles

# NixOS dotfiles on Apple M1 devices

## Why

Great laptops with Linux. If you do `aarch64` development, native is better than cross-compilation.

## Basic usage

```
nix flake update
sudo nixos-rebuild switch --flake .#blub --impure
```

`--impure` is required because of Apple firmware at `/boot/asahi`

## Prerequisities

* [Read these instructions](https://github.com/tpwrules/nixos-apple-silicon/blob/main/docs/uefi-standalone.md)
* Instead of just formatting the new root partition, use cryptsetup for LUKS

## Disk encryption with systemd-boot

When you have created the root partition to fill up the free space, use cryptsetup:

```
cryptsetup luksFormat -type luks1 /dev/nvme0n1p5
cryptsetup luksOpen /dev/nvme0n1p5 encrypted
pvcreate /dev/mapper/encrypted
vgcreate vg /dev/mapper/encrypted
lvcreate -L 16G -n swap vg
lvcreate -l '100%FREE' -n nixos vg
mkfs.ext4 -L nixos /dev/vg/nixos
mkswap -L swap /dev/vg/swap
swapon /dev/vg/swap
```

Continue with the instructions [from NixOS Configuration](https://github.com/tpwrules/nixos-apple-silicon/blob/main/docs/uefi-standalone.md#nixos-configuration).

After you've run `nixos-generate-config`, edit `configuration.nix`:

```
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = false;
# check the uuid of your partition with lsblk -f - NOTE: "encrypted" must match whatever you set with cryptsetup luksOpen
boot.initrd.luks.devices."encrypted".device = "/dev/disk/by-uuid/<uuid_of_your_/dev/nvme0n1p5>";
```

Continue the configuration and finish the NixOS Installation. Boot and type your LUKS password in NixOS Stage 1.

## What if something goes wrong?

* [Read these instructions](https://github.com/tpwrules/nixos-apple-silicon/blob/main/docs/uefi-standalone.md).
* Really. The instructions covers all but encrypting your disk.
* Really, even if you f your M1 internal NVMe - it covers the recovery with another Apple device.
    * Use idevicerestore and macOS 12.4.

## Thanks

* @tpwrules for [`nixos-apple-silicon`](https://github.com/tpwrules/nixos-apple-silicon)
* @yusernapora for above with flakes - [blog post worth reading](https://yusef.napora.org/blog/nixos-asahi/)

I only added disk encryption and simplified the flake config with M1 host only.