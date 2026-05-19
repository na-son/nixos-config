{...}: {
  programs.sdgr-hm.claude = {
    enable = true;
    enabledMcpServers = ["nixos"];
    extraSettings = {
      permissions = {
        allow = [
          "Read(//private/tmp/**)"
          "Bash(git worktree *)"
          "Bash(git branch *)"
          "Bash(nix eval *)"
          "mcp__mcp-nixos__nix"
          "Skill(update-config)"
          "WebSearch"
          "WebFetch(domain:github.com)"
          "WebFetch(domain:raw.githubusercontent.com)"
          "WebFetch(domain:google.github.io)"
          "WebFetch(domain:developers.google.com)"
          "Bash(alejandra *)"
          "Bash(statix check *)"
        ];
      };
    };
  };
}
