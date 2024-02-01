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

```shell
sudo nix run --extra-experimental-features 'nix-command flakes' github:/na-son/nixos-config#install
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
