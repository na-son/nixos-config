{
  config,
  pkgs,
  ...
}: {
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;

    secrets = {
      "gemini_settings/ATLASSIAN_MCP_URL" = {};
      "gemini_settings/JIRA_URL" = {};
      "gemini_settings/CONFLUENCE_URL" = {};

      "gemini_env_file" = {
        path = "${config.home.homeDirectory}/.gemini/.env";
      };
    };

    templates."gemini-settings.json" = {
      path = "${config.home.homeDirectory}/.gemini/settings.json";
      content = builtins.readFile ((pkgs.formats.json {}).generate "gemini-settings.json" {
        security.auth.selectedType = "oauth-personal";
        general = {
          previewFeatures = true;
          plan = {
            modelRouting = true;
            directory = "~/.plans";
          };
          enableNotifications = true;
          vimMode = true;
        };
        ui = {
          footer.hideContextPercentage = false;
          showModelInfoInChat = true;
          errorVerbosity = "full";
          theme = "GitHub";
          hideWindowTitle = true;
          inlineThinkingMode = "full";
          showStatusInTitle = true;
          showCitations = true;
          terminalBuffer = true;
          loadingPhrases = "witty";
        };
        experimental = {
          autoMemory = true;
          gemma = true;
          voiceMode = true;
          worktrees = true;
          modelSteering = true;
          directWebFetch = true;
          gemmaModelRouter = {
            enabled = true;
            autoStartServer = true;
          };
          contextManagement = true;
          generalistProfile = true;
        };
        mcpServers = {
          atlassian = {
            httpUrl = config.sops.placeholder."gemini_settings/ATLASSIAN_MCP_URL";
            env = {
              JIRA_URL = config.sops.placeholder."gemini_settings/JIRA_URL";
              CONFLUENCE_URL = config.sops.placeholder."gemini_settings/CONFLUENCE_URL";
            };
          };
          mcp-nixos.command = "mcp-nixos";
        };
        skills.disabled = [
          "triage-issue"
          "generate-status-report"
          "capture-tasks-from-meeting-notes"
        ];
        ide.enabled = true;
        model = {
          name = "gemini-3.1-pro-preview";
          compressionThreshold = 0.7;
        };
        context.loadMemoryFromIncludeDirectories = true;
        tools.sandboxNetworkAccess = true;
      });
    };
  };
}
