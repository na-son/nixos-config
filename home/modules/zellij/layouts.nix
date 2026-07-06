{
  config,
  lib,
  pkgs,
  kdl,
  zellijPlugins,
  zellijBars,
  zellijLayoutPicker,
  ...
}:
with lib; let
  cfg = config.features.apps.zellij;
  inherit (kdl) node plain leaf flag;
  inherit (zellijPlugins) panedAlias barAlias;
  inherit (zellijBars) barNode bottomBarNode;
  homeDir = config.home.homeDirectory;
  bash = "${pkgs.bashInteractive}/bin/bash";

  # Arguments handed to every layout module under ./layouts. Each layout is a
  # Nix file returning a KDL document (list of nodes); store paths and aliases
  # interpolate as ordinary Nix values, so no string templating is needed.
  layoutArgs = {
    inherit node plain leaf flag barNode bottomBarNode homeDir panedAlias barAlias lib bash;
    yaziSidebar = config.features.apps.yazi.sidebarCommand;
    layoutPicker = "${zellijLayoutPicker}/bin/zellij-layout-picker";
  };

  # Auto-discover every `<name>.kdl` -> `<name>.nix` layout in ./layouts: drop a
  # new file in that folder and it is registered as a Zellij layout.
  layouts =
    mapAttrs'
    (fname: _:
      nameValuePair
      (removeSuffix ".nix" fname)
      (kdl.serialize.nodes (import (./layouts + "/${fname}") layoutArgs)))
    (filterAttrs
      (n: t: t == "regular" && hasSuffix ".nix" n)
      (builtins.readDir ./layouts));
in {
  config = mkIf cfg.enable {
    programs.zellij.layouts = layouts;
  };
}
