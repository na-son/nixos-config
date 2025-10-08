# My nix config

Built off of https://github.com/dustinlyons/nixos-config

## Usage

### Macos

Install xcode + nix

```shell
xcode-select --install
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Bootstrap

```shell
mkdir ~/src
cd ~/src
git clone git@github.com:na-son/nixos-config.git
nix build .#darwinConfigurations.macos.system
./result/sw/bin/nh darwin switch
```

### Linux

Boot the [minimal installer](https://nixos.org/download)

THIS WILL WIPE YOUR DISKS AND APPLY THE PARTITION SCHEME IN
`./modules/nixos/disk-config.nix`

```shell
sudo nix --extra-experimental-features 'nix-command flakes' run 'github:nix-community/disko/latest#disko-install' -- --write-efi-boot-entries --flake 'github:na-son/nixos-config' --disk sda /
       │ dev/sda
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
nh os switch
```

To test changes you can also run:

```shell
nh os build
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

## Caveats

You may need to configure git for the root to trust this directory:

```shell
sudo su -
git config --system safe.directory = "/Users/ /nixos-config"
```

