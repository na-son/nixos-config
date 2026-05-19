{...}: {
  programs.sdgr-hm.claude = {
    enable = true;
    enabledMcpServers = ["nixos"];
    extraSettings = {
      permissions = {
        allow = [
          "Bash(nix run *)"
          "Read(//Users/nason/.gemini/**)"
          "Bash(sops secrets/secrets.yaml)"
          "Bash(cat)"
          "Read(//private/tmp/**)"
          "Bash(git worktree *)"
          "Bash(git branch *)"
          "Skill(update-config)"
          "Bash(ln -s AGENTS.md CLAUDE.md)"
          "Bash(ln -s AGENTS.md GEMINI.md)"
          "Bash(nix eval *)"
          "WebFetch(domain:google.github.io)"
          "WebSearch"
          "WebFetch(domain:github.com)"
          "WebFetch(domain:adk.dev)"
          "WebFetch(domain:developers.google.com)"
          "Read(//Users/nason/src/**)"
          "Bash(agents-cli scaffold *)"
          "Bash(uv sync *)"
          "Bash(uv run *)"
          "Bash(grep -E \"\\\\.md$\")"
          "Read(//tmp/**)"
          "Bash(echo \"Exit code: $?\")"
          "Bash(mv /Users/nason/src/adk-sysmgmt /Users/nason/src/nason-schrodan)"
          "Bash(rm /Users/nason/src/nason-schrodan/deployment_metadata.json)"
          "Bash(python3 -c ' *)"
          "Bash(alejandra home/modules/gemini.nix)"
          "Bash(nh darwin *)"
          "Bash(xargs -I {} sh -c 'echo \"=== {} ===\"; head -20 {}')"
          "mcp__mcp-nixos__nix"
          "WebFetch(domain:raw.githubusercontent.com)"
          "Bash(sops -d secrets/secrets.yaml)"
          "Bash(sops -d /Users/nason/src/nixos-config/secrets/secrets.yaml)"
          "Bash(alejandra *)"
          "Bash(env)"
          "Bash(statix check *)"
        ];
      };
    };
  };
}
