# AGENTS.md

This repository is system-only. It owns `darwinConfigurations.macos` and
`nixosConfigurations.luna`; do not add Home Manager inputs, outputs, embedded
modules, user dotfiles, zpak overlays, KDL helpers, or SOPS user secrets here.

Keep Homebrew and nix-darwin configuration in `hosts/darwin`, and NixOS/Disko
configuration in `hosts/nixos`. Shared system packages and services belong in
`hosts/default.nix`. The nixpkgs `home-manager` CLI package intentionally
remains available for activating the separate `~/src/flake` repository.

Apply the system first with `nh darwin switch ~/src/nixos-config` or
`nh os switch ~/src/nixos-config`, then apply `~/src/flake#nason-darwin` or
`~/src/flake#nason-linux` with `home-manager switch --flake`.

Format with `alejandra .`. Evaluate both system outputs before switching; do
not fold the existing `vaapiIntel` rename problem into Home Manager migration
work.
