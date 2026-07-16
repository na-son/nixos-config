{...}: {
  sdgr-hm.programs.claude.enable = true;

  programs.claude-code.settings = {
    model = "claude-opus-4-8";
    effortLevel = "auto";
    permissions.allow = [
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
    sandbox = {
      excludedCommands = [
        "Bash(nix eval *)"
        "Skill(update-config)"
      ];
      # Let sandboxed nix commands (nix fmt / nix flake check) write their
      # fetcher + eval caches; otherwise SQLite fails with "unable to open
      # database file".
      filesystem.allowWrite = ["~/.cache/nix"];
    };
  };
}
