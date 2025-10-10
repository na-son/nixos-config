## Shared
99% of the config.

This configuration gets imported by both modules.

## Layout
```
.
├── config             # Programs with complex configuration
├── default.nix        # Global config + Overlays
├── files.nix          # Immutable files
├── home-manager.nix   # home.packages {} config - 99% of the stuff
├── packages.nix       # List of packages to share

```
