# System configuration

This flake manages the `macos` nix-darwin system and the `luna` NixOS system.
User configuration is applied separately from the sibling standalone Home
Manager repository [`na-son/flake`](https://github.com/na-son/flake), which is
expected to be checked out at `../flake`.

## Switch

```sh
# macOS system, then user
nh darwin switch ~/src/nixos-config
home-manager switch --flake ../flake#nason-darwin

# NixOS system, then user
nh os switch ~/src/nixos-config
home-manager switch --flake ../flake#nason-linux
```

The system flake retains nix-darwin, NixOS, Homebrew, Disko, `nh`, and the
nixpkgs `home-manager` CLI package. It does not embed Home Manager modules or
produce a standalone home output.

For a new `luna` install, use the Disko configuration at
`hosts/nixos/disk-config.nix`; review the target disk before running any Disko
installation command.

Run `alejandra .` and evaluate both system outputs before switching. The known
`vaapiIntel` rename in current nixpkgs is tracked separately from this
Home Manager split.
