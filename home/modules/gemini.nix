{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.sdgr-hm.gemini = {
    enable = true;
    mcp.atlassian = {
      enable = true;
    };
  };
}
