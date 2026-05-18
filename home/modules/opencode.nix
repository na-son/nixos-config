{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.sdgr-hm.opencode = {
    enable = true;
  };
}
