{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.apps.yazi;

  yaziOpenInNvim = pkgs.writeShellApplication {
    name = "yazi-open-in-managed-nvim";
    runtimeInputs = with pkgs; [
      coreutils
      jq
      zellij
    ];
    text = ''
      if [ "$#" -eq 0 ]; then
        exit 0
      fi

      if [ -z "''${ZELLIJ_SESSION_NAME:-}" ] && [ -n "''${YAZELIX_ZELLIJ_SESSION_NAME:-}" ]; then
        export ZELLIJ_SESSION_NAME="$YAZELIX_ZELLIJ_SESSION_NAME"
      fi

      payload="$(
        jq -n \
          --arg working_dir "$(pwd -P)" \
          --args '{ editor: "neovim", working_dir: $working_dir, file_paths: $ARGS.positional }' \
          "$@"
      )"

      response="$(
        zellij action pipe \
          --plugin ${cfg.zellijPanedPluginAlias} \
          --name open_file \
          -- "$payload"
      )"

      case "$response" in
        ok)
          zellij action pipe --plugin ${cfg.zellijPanedPluginAlias} --name hide_sidebar -- "" >/dev/null 2>&1 || true
          ;;
        "")
          echo "paned did not return a response" >&2
          exit 1
          ;;
        *)
          echo "paned open_file failed: $response" >&2
          exit 1
          ;;
      esac
    '';
  };

  yaziSidebarStateLua = ''
    local PANE_PANED_PLUGIN_ALIAS = "${cfg.zellijPanedPluginAlias}"
    local REGISTER_RETRY_DELAYS_SECONDS = { 0, 0.15, 0.35, 0.75, 1.25 }
    local REGISTER_RETRYABLE_RESULTS = {
      command_failed = true,
      missing = true,
      no_response = true,
      not_ready = true,
    }
    local sidebar_state_generation = 0

    local function normalize_pane_id(value)
      if not value or value == "" then
        return nil
      end

      if value:find(":", 1, true) then
        return value
      end

      return "terminal:" .. value
    end

    local function current_cwd()
      if not cx or not cx.active or not cx.active.current then
        return nil
      end

      local cwd = cx.active and cx.active.current and cx.active.current.cwd
      if not cwd then
        return nil
      end

      return tostring(cwd)
    end

    local function json_escape(value)
      if value == nil then
        return ""
      end

      return tostring(value)
        :gsub("\\", "\\\\")
        :gsub('"', '\\"')
        :gsub("\n", "\\n")
        :gsub("\r", "\\r")
        :gsub("\t", "\\t")
    end

    local function trim(value)
      if value == nil then
        return ""
      end

      return tostring(value):gsub("^%s+", ""):gsub("%s+$", "")
    end

    local function zellij_command()
      local command = Command("zellij")
      local session_name = os.getenv("YAZELIX_ZELLIJ_SESSION_NAME")
      if session_name and session_name ~= "" then
        command:env("ZELLIJ_SESSION_NAME", session_name)
      end
      return command
    end

    local function pipe_sidebar_state_registration(payload)
      local output = zellij_command()
        :arg({
          "action",
          "pipe",
          "--plugin",
          PANE_PANED_PLUGIN_ALIAS,
          "--name",
          "register_sidebar_yazi_state",
          "--",
          payload,
        })
        :stdin(Command.NULL)
        :output()

      if not output or not output.status or not output.status.success then
        return "command_failed"
      end

      local response = trim(output.stdout)
      if response == "" then
        return "no_response"
      end

      return response
    end

    local function should_retry_registration_result(result)
      return REGISTER_RETRYABLE_RESULTS[result] == true
    end

    local function register_sidebar_state_with_paned(yazi_id, pane_id, cwd, generation)
      if not yazi_id or yazi_id == "" or not pane_id or pane_id == "" or not cwd or cwd == "" then
        return
      end

      local payload = string.format(
        '{"pane_id":"%s","yazi_id":"%s","cwd":"%s"}',
        json_escape(pane_id),
        json_escape(yazi_id),
        json_escape(cwd)
      )
      ya.async(function()
        for _, delay_seconds in ipairs(REGISTER_RETRY_DELAYS_SECONDS) do
          if generation ~= sidebar_state_generation then
            return
          end

          if delay_seconds > 0 then
            ya.sleep(delay_seconds)
          end

          if generation ~= sidebar_state_generation then
            return
          end

          local result = pipe_sidebar_state_registration(payload)
          if result == "ok" then
            return
          end
          if not should_retry_registration_result(result) then
            return
          end
        end
      end)
    end

    local function publish_sidebar_state()
      local normalized_pane_id = normalize_pane_id(os.getenv("ZELLIJ_PANE_ID"))
      local yazi_id = os.getenv("YAZI_ID")
      local cwd = current_cwd()

      if not normalized_pane_id or not yazi_id or yazi_id == "" or not cwd or cwd == "" then
        return
      end

      sidebar_state_generation = sidebar_state_generation + 1
      register_sidebar_state_with_paned(yazi_id, normalized_pane_id, cwd, sidebar_state_generation)
    end

    publish_sidebar_state()

    ps.sub("cd", function()
      publish_sidebar_state()
    end)
    ps.sub("tab", function()
      publish_sidebar_state()
    end)
  '';

  # Route selected files into the managed Neovim pane through Zellij paned.
  yaziBaseSettings = {
    opener.edit = [
      {
        run = "${yaziOpenInNvim}/bin/yazi-open-in-managed-nvim %s";
        desc = "Open in managed Neovim";
        for = "unix";
      }
    ];
  };
  yaziSettings =
    yaziBaseSettings
    // {
      plugin.prepend_fetchers = [
        {
          url = "*";
          run = "git";
          group = "git";
        }
        {
          url = "*/";
          run = "git";
          group = "git";
        }
      ];
    };

  # A dedicated YAZI_CONFIG_HOME for the narrow zellij sidebar: same opener and
  # sidebar-state plugin as the main config, but with the preview column removed
  # (`mgr.ratio` preview component set to 0). `YAZI_CONFIG_HOME` replaces the
  # whole config dir, so init.lua and the plugin are reproduced here too. The
  # full-screen `y` file manager keeps using ~/.config/yazi with its preview.
  yaziSidebarConfigHome = pkgs.runCommand "yazi-sidebar-config" {} ''
    mkdir -p $out
    cp ${(pkgs.formats.toml {}).generate "yazi.toml" (yaziBaseSettings
      // {
        mgr.ratio = [1 4 0];
      })} $out/yazi.toml
    cat <<'EOF' > $out/init.lua
    ${yaziSidebarStateLua}
    Status:children_remove(3, Status.LEFT) -- drop the path/"Desktop" segment
    EOF
  '';

  # Launches yazi for the sidebar with the preview-less config. zellij layouts
  # cannot set per-pane env vars, so the override is applied via this wrapper.
  yaziSidebar = pkgs.writeShellApplication {
    name = "yazi-sidebar";
    runtimeInputs = [pkgs.yazi];
    text = ''
      export YAZI_CONFIG_HOME="${yaziSidebarConfigHome}"
      exec yazi "$@"
    '';
  };
in {
  options.features.apps.yazi = {
    enable = mkEnableOption "Enable Yazi file-manager configuration";

    themeName = mkOption {
      type = types.str;
      default = "catppuccin-mocha";
      description = "The active Yazi flavor theme name.";
    };

    zellijPanedPluginAlias = mkOption {
      type = types.str;
      default = "paned";
      visible = false;
      description = "Zellij paned plugin alias used by the Yazi integration.";
    };

    sidebarCommand = mkOption {
      type = types.str;
      readOnly = true;
      visible = false;
      default = "${yaziSidebar}/bin/yazi-sidebar";
      description = "Yazi sidebar wrapper command consumed by the Zellij layouts.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.features.apps.zellij.enable;
        message = "features.apps.yazi requires features.apps.zellij because Yazi pipes opener and sidebar state through the Zellij paned plugin.";
      }
    ];

    programs = {
      lazygit.enable = true;

      yazi = {
        enable = true;
        shellWrapperName = "y";
        flavors = {
          theme = ./themes + "/${cfg.themeName}.yazi";
        };
        initLua = yaziSidebarStateLua;
        keymap.mgr.prepend_keymap = [
          {
            on = ["g" "l"];
            run = "plugin lazygit";
            desc = "Open lazygit";
          }
        ];
        plugins = {
          git = ./plugins/git.yazi;
          lazygit = ./plugins/lazygit.yazi;
          auto-layout = ./plugins/auto-layout.yazi;
          starship = {
            package = ./plugins/starship.yazi;
            setup = true;
          };
        };
        settings = yaziSettings;
        theme.flavor.dark = "theme";
        theme.flavor.light = "theme";
      };
    };
  };
}
