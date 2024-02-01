# My nix config

Built off of https://github.com/dustinlyons/nixos-config

## Usage

### Macos

Build system

```shell
nix run .#build
```

Make configuration active

```shell
nix run .#build-switch
```

### Linux

Boot the [minimal installer](https://nixos.org/download)

THIS WILL WIPE YOUR DISKS AND APPLY THE PARTITION SCHEME IN
`./modules/nixos/disk-config.nix`

```shell
sudo nix run --extra-experimental-features 'nix-command flakes' github:na-son/nixos-config#install
```

After the initial install completes and you land at the greeter, hit `CTRL+ALT+F6` to open a terminal and login as root.

Set a password for your user, and configure things like keyboard layout and drivers in `/etc/nixos/hosts/nixos/default.nix`.

```shell
passwd $user
logout
# login as $user
cd /etc/nixos
# make changes to the system config if necessary
sudo vim hosts/nixos/default.nix
nix run .#build-switch
```

To testi changes you can also run:

```shell
nixos-rebuild build --flake .#x86_64-linux
```

## Apps

Apps are included to sweeten the nix UX, for example `nix run .#build` replaces `nix build .#darwinConfigurations.macos.system`.

## Cachix

Generate an auth token [here](https://app.cachix.org/personal-auth-tokens)

```shell
# authenticate
cachix auth $auth-token

nix build $thing | cachix push $my-cachix
# example
nix --extra-experimental-features 'nix-command flakes' build .#darwinConfigurations.macos.system | cachix push na-son
# if "nothing to push" when you know there is something to push:
cachix push na-son ./result
```
