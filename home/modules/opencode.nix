{
  config,
  lib,
  pkgs,
  ...
}: {
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;

    secrets = {
      "claude_env/ANTHROPIC_VERTEX_PROJECT_ID" = {};
      "claude_env/CLOUD_ML_REGION" = {};
    };

    templates."opencode.json" = {
      path = "${config.home.homeDirectory}/.config/opencode/opencode.json";
      content = builtins.readFile config.home.file.".config/opencode/opencode.json".source;
    };
  };

  home.file.".config/opencode/opencode.json".enable = lib.mkForce false;

  programs.sdgr-hm.opencode = {
    enable = true;
    vertex.projectId = config.sops.placeholder."claude_env/ANTHROPIC_VERTEX_PROJECT_ID";
    vertex.region = config.sops.placeholder."claude_env/CLOUD_ML_REGION";
  };
}
