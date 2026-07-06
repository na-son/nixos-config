{
  config,
  lib,
  pkgs,
  kdl,
  zellijPlugins,
  zellijHarnesses,
  zellijBars,
  ...
}:
with lib; let
  cfg = config.features.apps.zellij;

  inherit
    (zellijPlugins)
    panedAlias
    barAlias
    hintsAlias
    agentsAlias
    agentManagerAlias
    panedPlugin
    barPlugin
    hintsPlugin
    recallPlugin
    agentsPlugin
    agentManagerPlugin
    permissionsKdl
    permFile
    barWidget
    ;

  inherit
    (zellijHarnesses)
    harnessesStr
    harnessCommands
    ;

  homeDir = config.home.homeDirectory;
  projectsDir = "${homeDir}/src";
  worktreesDir = "${homeDir}/worktrees";

  inherit (zellijBars) barNode bottomBarNode;
  inherit (kdl) node leaf;

  agentsTabLayout = kdl.serialize.nodes [
    (node "layout" {} [
      (node "tab" {name = "{}";} [
        barNode
        (node "pane" {split_direction = "vertical";} [
          (node "pane" {
              size = "20%";
              borderless = true;
              focus = true;
            } [
              (leaf "plugin" {location = agentsAlias;})
            ])
          (node "pane" {stacked = true;} [
            (node "pane" {name = "worktrees";} [
              (leaf "plugin" {location = agentManagerAlias;})
            ])
          ])
        ])
        bottomBarNode
      ])
    ])
  ];
  tasksDir = "${homeDir}/worktrees/tasks";
in {
  imports = [
    ./plugins.nix
    ./harnesses.nix
    ./bars.nix
    ./layout-picker.nix
    ./layouts.nix
    ./keybinds.nix
  ];

  options.features.apps.zellij = {
    enable = mkEnableOption "Enable Zellij multiplexer configuration";
  };

  config = mkIf cfg.enable {
    features.apps.yazi = {
      enable = mkDefault true;
      zellijPanedPluginAlias = mkDefault panedAlias;
    };

    home = {
      # `native_widget` and its `tu` provider must be on PATH for the bar's
      # command widgets.
      packages = [pkgs.widget pkgs.tokenusage];

      # Creates a read/write org dir
      activation.ensureOrgDir =
        lib.hm.dag.entryAfter ["writeBoundary"] "$DRY_RUN_CMD mkdir -p $HOME/org";

      # Pre-grant each managed plugin's required permissions so Zellij never
      # raises a permission prompt for these pinned aliases after rebuilds.
      # Written as a real, writable file via `install` — not a store symlink — so
      # Zellij can still amend it; regenerated each switch to stay deterministic.
      activation.zellijPluginPermissions = lib.hm.dag.entryAfter ["writeBoundary"] ''
        permFile="${permFile}"
        $DRY_RUN_CMD mkdir -p "$(dirname "$permFile")"
        $DRY_RUN_CMD install -m644 ${permissionsKdl} "$permFile"
      '';
    };

    programs = {
      lazygit.enable = true;

      # Auto-start Zellij only for remote (SSH) interactive shells, so local
      # interactive shells — e.g. `nix develop` subshells — don't spawn a session.
      # Replaces the home-manager bash integration (disabled below), which starts
      # Zellij on every non-dumb interactive shell. The generated script still
      # guards on $ZELLIJ, so shells nested inside a session won't relaunch.
      bash.initExtra = ''
        if [[ "$TERM" != "dumb" ]] && [[ -n "''${SSH_CONNECTION:-}''${SSH_TTY:-}" ]]; then
          eval "$(${lib.getExe config.programs.zellij.finalPackage} setup --generate-auto-start bash)"
        fi
      '';

      zellij = {
        enable = true;
        # Auto-start is handled by the SSH-gated `bash.initExtra` above instead of
        # the module's blanket "start on every interactive shell" integration.
        enableBashIntegration = false;

        # The bar and paned wasm files are symlinked to stable paths
        # under ~/.config/zellij/plugins and aliased automatically.
        plugins = [panedPlugin barPlugin hintsPlugin recallPlugin agentsPlugin agentManagerPlugin];

        settings = {
          default_layout = "chill";
          theme = "catppuccin-mocha";
          pane_frames = true;
          show_startup_tips = false;
          scroll_buffer_size = 5000;
          ui.pane_frames.rounded_corners = true;

          # Catppuccin Mocha, defined explicitly rather than relying on a bundled
          # theme (this Zellij build ships none by name). Palette mapping matches
          # the upstream catppuccin/zellij definition.
          themes.catppuccin-mocha = {
            bg = "#585b70"; # Surface2
            fg = "#cdd6f4"; # Text
            red = "#f38ba8";
            green = "#a6e3a1";
            blue = "#89b4fa";
            yellow = "#f9e2af";
            magenta = "#f5c2e7"; # Pink
            orange = "#fab387"; # Peach
            cyan = "#89dceb"; # Sky
            black = "#181825"; # Mantle
            white = "#cdd6f4"; # Text
          };

          # `programs.zellij.plugins` only fills in `_props.location` for the
          # paned alias; re-add the config arg the old inline block set.
          plugins = {
            ${agentsAlias} =
              {
                mode = "sidebar";
                manager_alias = agentManagerAlias;
                harnesses = harnessesStr;
                hints_alias = hintsAlias;
                theme = "mocha";
              }
              // harnessCommands;
            ${agentManagerAlias} =
              {
                mode = "manager";
                harnesses = harnessesStr;
                projects_dir = projectsDir;
                worktrees_dir = worktreesDir;
                tasks_dir = tasksDir;
                hints_alias = hintsAlias;
                theme = "mocha";
              }
              // harnessCommands;
            ${panedAlias} = {
              screen_saver_enabled = false;
              agents_tab_name = "agents";
              agents_alias = agentsAlias;
              manager_alias = agentManagerAlias;
              autocreate_marker_tab = "IDE";
              bar_alias = barAlias;
              hints_alias = hintsAlias;
              shell_command = "${pkgs.bashInteractive}/bin/bash";
              bar_widget_command = "${barWidget}";
              agents_tab_layout_kdl = agentsTabLayout;
            };
          };

          # The plugins module auto-loads every plugin headlessly at startup.
          # Only the paned plugin wants that; the bar renders inside layout panes.
          load_plugins = lib.mkForce {
            _children = [
              {${panedAlias} = [];}
            ];
          };
        };
      };
    };
  };
}
