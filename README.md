# nixos-config

I usually use NixOS inside of a VMWare Fusion VM, where the host OS is macOS.
Config is partially based on https://github.com/mitchellh/nixos-config

---

## Setup
*By mitchellh*

Video: https://www.youtube.com/watch?v=ubDMLoWz76U

If you need an ISO for NixOS, you can build your own in the `iso` folder.
For x86-64, I usually just download the official ISO, but I build the
ISO from scratch for aarch64. There is a make target `iso/nixos.iso` you can use for
building an ISO. You'll also need a `docker` running on your machine for building an ISO.

```
$ make iso/nixos.iso
```

Create a VMware Fusion VM with the following settings. My configurations
are made for VMware Fusion exclusively currently and you will have issues
on other virtualization solutions without minor changes.

  * ISO: NixOS 21.11 or later.
  * Disk: SATA 150 GB+
  * CPU/Memory: I give at least half my cores and half my RAM, as much as you can.
  * Graphics: Full acceleration, full resolution, maximum graphics RAM.
  * Network: Shared with my Mac.
  * Remove sound card, remove video camera.
  * Profile: Disable almost all keybindings

Boot the VM, and using the graphical console, change the root password to "root":

```
$ sudo su
$ passwd
# change to root
```

Run `ifconfig` and get the IP address of the first device. It is probably
`192.168.58.XXX`, but it can be anything. In a terminal with this repository
set this to the `NIXADDR` env var:

```
$ export NIXADDR=<VM ip address>
```

The Makefile assumes an Intel processor by default. If you are using an
ARM-based processor (M1, etc.), you must change `NIXNAME` so that the ARM-based
configuration is used:

```
$ export NIXNAME=vm-aarch64
```

Perform the initial bootstrap. This will install NixOS on the VM disk image
but will not setup any other configurations yet. This prepares the VM for
any NixOS customization:

```
$ make vm/bootstrap0
```

After the VM reboots, run the full bootstrap, this will finalize the
NixOS customization using this configuration:

```
$ make vm/bootstrap
```

You should have a graphical functioning dev VM.

At this point, I never use Mac terminals ever again. I clone this repository
in my VM and I use the other Make tasks such as `make test`, `make switch`, etc.
to make changes my VM.

---

## Setup within VM

This config assumes that this directory is cloned at `/home/cor/nixos-config` and linked to `/etc/nixos`.

1. copy over `id_ed25519` and `id_ed25519.pub` from the host's `~/.ssh/` directory to the VM's `~/.ssh/` directory
2. `git clone git@github.com:cor/nixos-config`
3. `sudo mv /etc/nixos /etc/nixos-pre-git-backup`
4. `sudo ln -s /home/cor/nixos-config /etc/nixos`

After that is done, rebuild the system and import your GPG keys.
