{
  config,
  pkgs,
  ...
}: let
  # Layout picker for the default session's "Layouts" tab. Lists every installed
  # layout (auto-discovered from the layout dir, so new `./layouts/*.nix` files
  # show up for free) and, on selection, transforms the current session into that
  # layout: it applies the chosen layout's tabs via `new-tab --layout`, then
  # closes every pre-existing tab by stable id (its own host tab last), so no tab
  # or pane outside the selected layout survives. Esc drops to a shell so the tab
  # stays usable instead of collapsing.
  layoutDir = "${config.xdg.configHome}/zellij/layouts";
  layoutPicker = pkgs.writeShellApplication {
    name = "zellij-layout-picker";
    runtimeInputs = with pkgs; [coreutils fzf jq zellij bashInteractive];
    text = ''
      layout_dir="${layoutDir}"

      while true; do
        mapfile -t names < <(
          find -L "$layout_dir" -maxdepth 1 -type f -name '*.kdl' -printf '%f\n' 2>/dev/null \
            | sed 's/\.kdl$//' | sort
        )
        if [ "''${#names[@]}" -eq 0 ]; then
          echo "No layouts found in $layout_dir" >&2
          exec bash
        fi

        pick="$(
          printf '%s\n' "''${names[@]}" \
            | fzf --prompt='layout> ' --height=100% --border --reverse \
                  --header='Transform session into layout  (Esc: shell)'
        )" || exec bash
        [ -n "$pick" ] || exec bash

        # Snapshot tabs before adding new ones; the active tab is this picker's host.
        tabs_json="$(zellij action list-tabs --json)"
        self="$(jq '[.[] | select(.active)][0].tab_id' <<<"$tabs_json")"
        mapfile -t orig < <(jq -r '.[].tab_id' <<<"$tabs_json")

        zellij action new-tab --layout-dir "$layout_dir" --layout "$pick"

        # Drop every original tab. Close the host tab last: doing so kills this
        # script, so anything after it would not run.
        for id in "''${orig[@]}"; do
          [ "$id" = "$self" ] || zellij action close-tab-by-id "$id"
        done
        zellij action close-tab-by-id "$self"
        exit 0
      done
    '';
  };
in {
  _module.args.zellijLayoutPicker = layoutPicker;
}
