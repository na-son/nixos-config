{config, ...}: {
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;

    secrets = {
      "claude_env/ANTHROPIC_VERTEX_BASE_URL" = {};
      "claude_env/ANTHROPIC_VERTEX_PROJECT_ID" = {};
      "claude_env/CLOUD_ML_REGION" = {};
      "claude_env/CLAUDE_CODE_USE_VERTEX" = {};
      "claude_env/CLAUDE_CODE_SKIP_VERTEX_AUTH" = {};
      "claude_env/CLAUDE_CODE_API_KEY_HELPER_TTL_MS" = {};
    };

    templates."claude.env".content = ''
      export ANTHROPIC_VERTEX_BASE_URL="${config.sops.placeholder."claude_env/ANTHROPIC_VERTEX_BASE_URL"}"
      export ANTHROPIC_VERTEX_PROJECT_ID="${config.sops.placeholder."claude_env/ANTHROPIC_VERTEX_PROJECT_ID"}"
      export CLOUD_ML_REGION="${config.sops.placeholder."claude_env/CLOUD_ML_REGION"}"
      export CLAUDE_CODE_USE_VERTEX="${config.sops.placeholder."claude_env/CLAUDE_CODE_USE_VERTEX"}"
      export CLAUDE_CODE_SKIP_VERTEX_AUTH="${config.sops.placeholder."claude_env/CLAUDE_CODE_SKIP_VERTEX_AUTH"}"
      export CLAUDE_CODE_API_KEY_HELPER_TTL_MS="${config.sops.placeholder."claude_env/CLAUDE_CODE_API_KEY_HELPER_TTL_MS"}"
    '';
  };

  programs.claude-code = {
    enable = true;

    settings = {
      theme = "dark";

      apiKeyHelper = "~/.claude/get-iam-token.sh";
      autoUpdatesChannel = "latest";
    };
  };

  programs.zsh.initExtra = ''
    if [ -f "${config.sops.templates."claude.env".path}" ]; then
      source "${config.sops.templates."claude.env".path}"
    fi
  '';
}
