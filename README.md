# My nix config

Built off of https://github.com/dustinlyons/nixos-config

## Usage

Build system

```shell
nix run .#build
```

Make configuration active

```shell
nix run .#build-switch
```

First run will be slow, as nix needs to download and compile everything. You will appreciate this when you rebuild and everything is cached.

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
```
