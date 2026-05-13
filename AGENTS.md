# AGENTS.md

Guidance for AI coding agents working in this repo. Keep responses short; prefer editing existing modules over adding new ones.

## What this is

A personal Nix flake managing two hosts:

- **`macos`** — aarch64-darwin, via `nix-darwin` + `nix-homebrew`
- **`luna`** — x86_64-linux NixOS, partitioned via `disko`

`home-manager` is wired in **two ways**:

1. **As a module** of `darwinConfigurations.macos` and `nixosConfigurations.luna` — used on hosts we own. User-level changes ship with `nh darwin switch` / `nh os switch`.
2. **As standalone `homeConfigurations.nason`** — for foreign hosts where we can't or don't want to manage the system config. Activate with `nh home switch --impure` (the config uses `builtins.currentSystem` to pick the right pkgs).

Pick **one** path per machine — running both writes overlapping profiles and causes confusing rollbacks.

Channel: `nixos-unstable`. Single user `nason` is injected via `specialArgs.user`; don't parameterize without asking.

## Build & switch

Use [`nh`](https://github.com/viperML/nh). The flake refs are exported by `.envrc`:

| What | Command | Resolves to |
|---|---|---|
| Apply system (macOS) | `nh darwin switch` | `.#macos` |
| Apply system (NixOS) | `nh os switch` | `.#luna` |
| Apply user only (foreign host) | `nh home switch --impure` | `.#nason` (auto-resolves from `$USER`) |
| Build only, no activate | `nh darwin build` / `nh os build` / `nh home build` | same |
| GC old generations | `nh clean all` | — |
| Update inputs | `nix flake update` then re-switch | — |

`nh` runs `nix flake check`-style evaluation and shows a diff before activating. Prefer it over raw `darwin-rebuild` / `nixos-rebuild`.

## Layout

```
flake.nix              inputs + darwinConfigurations.macos + nixosConfigurations.luna
hosts/
  default.nix          shared system config (both platforms)
  darwin/default.nix   macOS-specific (homebrew, dock, Touch ID sudo)
  nixos/default.nix    luna host (sway, greetd, pipewire, drivers)
  nixos/disk-config.nix  disko partitioning
home/
  home.nix             home-manager entry (imports modules + sops)
  packages.nix         user CLI/GUI packages
  modules/*.nix        per-program HM modules (git, zsh, sway, nvf, ...)
secrets/secrets.yaml   sops-encrypted (age)
```

## Where to add things

- **System package or service** → `hosts/default.nix` (shared) or `hosts/{darwin,nixos}/default.nix` (platform-specific).
- **User CLI tool** → append to `home/packages.nix`.
- **Configured user program** (with dotfiles/options) → new file in `home/modules/`, then add to the `imports` list in `home/home.nix`.
- **Platform-conditional home config** → use `lib.mkIf pkgs.stdenv.isDarwin` / `isLinux`. See `home/home.nix` for the pattern.

## Looking things up — use the `mcp-nixos` MCP server

**Always** query `mcp-nixos` before suggesting a package, option, or attribute path. Your training data lags nixpkgs by months. Do this even when you're confident.

Common calls (copy the JSON shape):

- Package exists? — `nix {"action":"info","query":"foo","channel":"unstable"}`
- Search packages — `nix {"action":"search","query":"foo"}`
- NixOS option — `nix {"action":"search","query":"services.foo","type":"options"}`
- home-manager option — `nix {"action":"search","source":"home-manager","query":"programs.foo"}`
- nix-darwin option — `nix {"action":"search","source":"darwin","query":"system.defaults"}`
- Which commit shipped version X — `nix_versions {"package":"foo","version":"1.2.3"}`

## Format & lint

Inside `nix develop` (or via direnv, automatic):

- `alejandra .` — format (required before commit)
- `statix check` — lint
- `deadnix` — find dead code

## Secrets (sops-nix + age)

- Age key lives at `~/.config/sops/age/keys.txt` (path exported as `SOPS_AGE_KEY` in `.envrc`).
- Edit secrets: `sops secrets/secrets.yaml`.
- Recipients are configured in `.sops.yaml`.
- Secrets are exposed via the home-manager sops module imported in `home/home.nix`. Reference them as `config.sops.secrets.<name>.path` from HM modules.

## Gotchas

- Keyboard layout is **Dvorak** (`home.keyboard.variant = "dvorak"`).
- macOS host uses `nix-homebrew` with `mutableTaps = false`; declare casks/brews in the darwin config, not via `brew install`.
- `nvf` (NotAShelf/nvf) is the Neovim framework — edit `home/modules/nvf.nix`, not init.lua.
- `useGlobalPkgs = true` in HM means home-manager shares the system nixpkgs instance; don't set `home-manager.users.<u>.nixpkgs.*`.
