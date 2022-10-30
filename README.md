# nixos-config

I usually use NixOS inside of a Parallels VM, where the host OS is macOS.
Config is partially based on https://github.com/mitchellh/nixos-config

## How to fork this configuration for your own usage.

1. Do a project-wide search of my username, `cor` and replace it with `your_username`. Be careful not to replace things that are not my username, such as "core".
2. In `./nixos.nix`, replace the value of `hashedPassword` with one you've generated with `mkpasswd -m sha-512` [See here for more info](https://search.nixos.org/options?channel=22.05&show=users.users.%3Cname%3E.hashedPassword&from=0&size=50&sort=relevance&type=packages&query=users.users.%3Cname%3E.hash).
3. In `./home.nix`, change `programs.git.userName` and `programs.git.extraConfig.github.user` to your GitHub username. Also change `programs.git.signing.key` to the public GPG key you use for your GitHub account.

## Setup

**Note:** This setup guide will cover VMware Fusion because that is the
hypervisor I use day to day. The configurations in this repository also
work with UTM (see `vm-aarch64-utm`) but I'm not using that full time so they
may break from time to time.

If you need an ISO for NixOS:
- x86-64: download the 64-bit minimal image [from the official image here](https://nixos.org/download.html) 
- aarch64: get one from [Hydra](https://hydra.nixos.org/project/nixos)

Create a VMware Fusion or Parallels VM with the following settings. My configurations
are made for VMware Fusion exclusively currently and you will have issues
on other virtualization solutions without minor changes.

  * ISO: NixOS 22.05 or later.
  * Disk: SATA 150 GB+
  * CPU/Memory: I give at least half my cores and half my RAM, as much as you can.
  * Graphics: Full acceleration, full resolution, maximum graphics RAM.
  * Network: Shared with my Mac.
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

**Other Hypervisors:** If you are using Parallels, use `vm-aarch64-prl`.
If you are using UTM, use `vm-aarch64-utm`. Note that the environments aren't
_exactly_ equivalent between hypervisors but they're very close and they
all work. Check the `./flake.nix` to see which `nixosConfigurations` are defined.

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

Then, inside of your `/home/user_name`, clone your fork:

```bash
git clone git@github.com:user_name/nixos-config
```

Now, you can make any changes to this configuration you need, and run `make switch` in order to load your new configuration.

