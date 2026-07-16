{
  inputs,
  lib,
  pkgs,
  user,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.sdgr-hm.homeManagerModules.default
    ./modules/claude.nix
    ./modules/codex.nix
    ./modules/direnv.nix
    ./modules/gemini.nix
    ./modules/ghostty.nix
    ./modules/git.nix
    ./modules/nvf.nix
    ./modules/opencode.nix
    ./modules/ssh.nix
    ./modules/starship.nix
    ./modules/sway.nix
    ./modules/yazi
    ./modules/zed.nix
    ./modules/zellij
    ./modules/zsh.nix
    ./packages.nix
  ];

  # Zellij multiplexer + Yazi sidebar, vendored from ~/src/zpak. The zellij
  # module auto-enables the yazi integration.
  features.apps.zellij.enable = true;

  # Shared MCP server registry. Each sdgr-hm agent module (claude, codex,
  # gemini, opencode) pulls this via its `enableMcpIntegration` flag. sdgr-hm
  # defaults in atlassian/github/google(nixos); keep only nixos + atlassian.
  sdgr-hm.programs.mcp.enable = true;
  programs.mcp.servers = {
    github.enabled = false;
    calendar.enabled = false;
    docs.enabled = false;
    chat.enabled = false;
  };

  home = {
    username = "${user.name}";

    homeDirectory = lib.mkDefault (
      if pkgs.stdenv.isLinux
      then "/home/${user.name}"
      else "/Users/${user.name}"
    );

    keyboard = {
      layout = "us";
      variant = "dvorak";
    };

    stateVersion = "23.11";
  };

  manual.manpages.enable = false;

  #programs = { };
}
