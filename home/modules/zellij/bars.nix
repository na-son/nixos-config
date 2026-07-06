{
  kdl,
  zellijPlugins,
  ...
}: let
  inherit (kdl) node leaf;
  inherit (zellijPlugins) barAlias hintsAlias barWidget;

  # The zbar top bar, shared by every layout. References the bar by its
  # managed plugin alias (see `programs.zellij.plugins`) rather than a store path.
  # Built once as a KDL node and threaded into each layout via `layoutArgs`.
  barNode =
    node "pane" {
      size = 1;
      borderless = true;
    } [
      (node "plugin" {location = barAlias;} [
        (leaf "format_left" "{mode} {tabs}")
        (leaf "format_center" "")
        (leaf "format_right" "#[fg=#f38ba8,bold]{session}{command_claude_usage}{command_codex_usage}{command_cpu}{command_ram} #[fg=#cba6f7,bold]{datetime}")
        (leaf "format_hide_on_overlength" "true")
        (leaf "format_precedence" "lrc")
        (leaf "format_space" "")

        (leaf "border_enabled" "false")

        (leaf "mode_normal" "#[bg=#a6e3a1,fg=#1e1e2e,bold] NORMAL ")
        (leaf "mode_tmux" "#[bg=#f9e2af,fg=#1e1e2e,bold] TMUX ")
        (leaf "mode_session" "#[bg=#fab387,fg=#1e1e2e,bold] SESSION ")
        (leaf "mode_scroll" "#[bg=#f38ba8,fg=#1e1e2e,bold] SCROLL ")

        (leaf "tab_normal" "#[fg=#f9e2af] [{index}] {name} ")
        (leaf "tab_normal_fullscreen" "#[fg=#f9e2af] [{index}] {name} [] ")
        (leaf "tab_normal_sync" "#[fg=#f9e2af] [{index}] {name} <> ")
        (leaf "tab_normal_bell" "#[fg=#f38ba8,bold] [{index}] {name} {sync_indicator}{fullscreen_indicator}{bell_indicator}")
        (leaf "tab_normal_flashing_bell" "#[bg=#f38ba8,fg=#1e1e2e,bold] [{index}] {name} {sync_indicator}{fullscreen_indicator}{bell_indicator}")
        (leaf "tab_active" "#[bg=#fab387,fg=#1e1e2e,bold] [{index}] {name} {floating_indicator}")
        (leaf "tab_active_fullscreen" "#[bg=#fab387,fg=#1e1e2e,bold] [{index}] {name} {fullscreen_indicator}")
        (leaf "tab_active_sync" "#[bg=#fab387,fg=#1e1e2e,bold] [{index}] {name} {sync_indicator}")
        (leaf "tab_separator" "")
        (leaf "tab_rename" "#[bg=#fab387,fg=#1e1e2e,bold] {index} {name} {floating_indicator} ")
        (leaf "tab_sync_indicator" "<> ")
        (leaf "tab_fullscreen_indicator" "[] ")
        (leaf "tab_floating_indicator" "o ")
        (leaf "tab_bell_indicator" "! ")
        (leaf "tab_flashing_bell_indicator" "!! ")
        (leaf "tab_display_count" "6")
        (leaf "tab_truncate_start_format" "#[fg=#fab387,bold]< +{count} ... ")
        (leaf "tab_truncate_end_format" "#[fg=#fab387,bold]... +{count} > ")

        (leaf "datetime" "#[fg=#cba6f7,bold] {format} ")
        (leaf "datetime_format" "%H:%M")

        (leaf "command_cpu_command" "${barWidget} cpu")
        (leaf "command_cpu_format" " #[fg=#fab387]{stdout}")
        (leaf "command_cpu_interval" "5")
        (leaf "command_ram_command" "${barWidget} ram")
        (leaf "command_ram_format" " #[fg=#fab387]{stdout}")
        (leaf "command_ram_interval" "5")
        (leaf "command_claude_usage_command" "${barWidget} claude")
        (leaf "command_claude_usage_format" " #[fg=#cba6f7,bold]{stdout}")
        (leaf "command_claude_usage_interval" "10")
        (leaf "command_codex_usage_command" "${barWidget} codex")
        (leaf "command_codex_usage_format" " #[fg=#cba6f7,bold]{stdout}")
        (leaf "command_codex_usage_interval" "10")
      ])
    ];

  # A second, bottom zbar instance dedicated to the native mode keybind hints.
  bottomBarNode =
    node "pane" {
      size = 1;
      borderless = true;
    } [
      (node "plugin" {location = hintsAlias;} [
        (leaf "format_left" "#[fg=#cdd6f4]{hints}")
        (leaf "format_center" "")
        (leaf "format_right" "{bells}")
        (leaf "bell_format" "#[fg=#f38ba8,bold]! activity in [{index}] {name} ")
        (leaf "bell_separator" "#[fg=#585b70]| ")
        (leaf "border_enabled" "false")
      ])
    ];
in {
  _module.args.zellijBars = {
    inherit barNode bottomBarNode;
  };
}
