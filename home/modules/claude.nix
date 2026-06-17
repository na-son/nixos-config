{...}: {
  programs.sdgr-hm.claude = {
    enable = true;
    enabledMcpServers = ["nixos"];
    extraSettings = {
      attribution = {
        commit = "";
        pr = "";
      };

      defaultMode = "plan";
      model = "claude-opus-4-8";
      effortLevel = "auto";
      mcpToolSearch = true;
      skipWebFetchPreflight = true;
      tui = "fullscreen";
      worktree = {
        baseRef = "head";
        bgIsolation = "worktree";
      };
      statusLine = {
        type = "command";
        command = "~/.claude/statusline.sh";
        padding = 0;
      };

      permissions = {
        allow = [
          "Read(//private/tmp/**)"
          "Bash(git worktree *)"
          "Bash(git checkout *)"
          "Bash(git stash *)"
          "Bash(git branch *)"
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
        ask = [
          "Bash(git push *)"
          "Bash(git commit *)"
          "Bash(git add *)"
          "Bash(git rm *)"
          "Bash(git tag *)"
        ];
      };
      sandbox = {
        enabled = true;
        enableWeakerNetworkIsolation = true;
        excludedCommands = [
          "Bash(nix eval *)"
          "Skill(update-config)"
        ];
      };
    };
  };
}
