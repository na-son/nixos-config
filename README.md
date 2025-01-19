# My nix config

Built off of https://github.com/dustinlyons/nixos-config

## Usage

### Macos

Install xcode bits

```shell
xcode-select --install
```

Install nix

```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Build system (optional)

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

## Secret Management with YubiKey and SOPS

This configuration uses [sops-nix](https://github.com/Mic92/sops-nix) with YubiKey integration for secure secret management on macOS.

### Initial Setup

1. Run the YubiKey setup script:
```shell
./scripts/setup-yubikey-age.sh
```

This script will:
- Create required directories
- Install age-plugin-yubikey
- Generate an age identity from your YubiKey
- Configure .sops.yaml for encryption

2. Install and configure sops:
```shell
# Install sops
nix-shell -p sops

# Edit your secrets (automatically encrypts the file)
sops secrets/secrets.yaml
```

### Secret Locations

The following secrets are managed:
- SSH Keys:
  - Private key: `~/.ssh/id_ed25519`
  - Public key: `~/.ssh/id_ed25519.pub`
- macOS Keychain: `~/Library/Keychains/login.keychain-db`

### Usage

1. Edit secrets:
```shell
sops secrets/secrets.yaml
```

2. Apply changes:
```shell
darwin-rebuild switch --flake .#macos
```

### Important Notes

- **Backup**: Keep a secure backup of `~/.config/sops/age/keys.txt`
- **Version Control**: The encrypted `secrets.yaml` file is safe to commit
- **YubiKey Required**: Insert your YubiKey before rebuilding the system
- **Adding Secrets**: 
  1. Add new secrets to `secrets.yaml`
  2. Update secret paths in `modules/darwin/secrets.nix`
