{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  barWasm = "${pkgs.zbar}/zbar.wasm";
  barWidget = "${pkgs.widget}/bin/native_widget";
  panedWasm = "${pkgs.paned}/paned.wasm";
  panedAlias = "paned";
  barAlias = "zellij_bar";
  hintsAlias = "zellij_hints";
  agentsAlias = "agents";
  agentManagerAlias = "agent_manager";
  agentsWasm = "${pkgs.agents}/agents.wasm";

  # `programs.zellij.plugins` symlinks each package directly to
  # `~/.config/zellij/plugins/<name>.wasm` (name derived from `pname`), so the
  # package output must *be* the wasm file. The upstream flake packages are
  # directories (`…/share/<plugin>/<file>.wasm`), so wrap their wasm here. The
  # `pname` chosen here becomes the plugin alias used in layouts/keybinds.
  mkWasmPlugin = pname: wasm:
    pkgs.stdenvNoCC.mkDerivation {
      inherit pname;
      version = "0.1.0";
      dontUnpack = true;
      installPhase = "cp ${wasm} $out";
    };
  panedPlugin = mkWasmPlugin panedAlias panedWasm;
  barPlugin = mkWasmPlugin barAlias barWasm;
  hintsPlugin = mkWasmPlugin hintsAlias barWasm;
  agentsPlugin = mkWasmPlugin agentsAlias agentsWasm;
  agentManagerPlugin = mkWasmPlugin agentManagerAlias agentsWasm;

  # recall (rust/recall, packaged by pkgs/recall) is an on-demand floating
  # keybind-recall pane: the running session's keybinds with incremental
  # filtering.
  recallAlias = "recall";
  recallWasm = "${pkgs.recall}/recall.wasm";
  recallPlugin = mkWasmPlugin recallAlias recallWasm;

  # Custom wasm plugins are symlinked under ~/.config/zellij/plugins. Pre-grant
  # only the permissions each managed plugin requests so Zellij does not prompt
  # on every rebuild while still keeping plugin capabilities explicit.
  pluginPermissions = {
    ${panedAlias} = [
      "ReadApplicationState"
      "ChangeApplicationState"
      "OpenTerminalsOrPlugins"
      "WriteToStdin"
      "ReadCliPipes"
      "RunCommands"
    ];
    ${barAlias} = [
      "ReadApplicationState"
      "ChangeApplicationState"
      "RunCommands"
    ];
    ${hintsAlias} = [
      "ReadApplicationState"
      "ChangeApplicationState"
      "RunCommands"
    ];
    ${recallAlias} = [
      "ReadApplicationState"
      "ChangeApplicationState"
    ];
    ${agentsAlias} = [
      "ReadApplicationState"
      "ChangeApplicationState"
      "OpenTerminalsOrPlugins"
      "RunCommands"
      "MessageAndLaunchOtherPlugins"
    ];
    ${agentManagerAlias} = [
      "ReadApplicationState"
      "ChangeApplicationState"
      "OpenTerminalsOrPlugins"
      "RunCommands"
      "MessageAndLaunchOtherPlugins"
    ];
  };
  pluginPackages = {
    ${panedAlias} = panedPlugin;
    ${barAlias} = barPlugin;
    ${hintsAlias} = hintsPlugin;
    ${recallAlias} = recallPlugin;
    ${agentsAlias} = agentsPlugin;
    ${agentManagerAlias} = agentManagerPlugin;
  };

  permissionsKdl = pkgs.writeText "zellij-permissions.kdl" (
    concatMapStrings (alias: let
      perms = concatMapStrings (p: "    ${p}\n") pluginPermissions.${alias};
    in ''
      "${alias}" {
      ${perms}}
      "file:${config.xdg.configHome}/zellij/plugins/${alias}.wasm" {
      ${perms}}
      "${config.xdg.configHome}/zellij/plugins/${alias}.wasm" {
      ${perms}}
      "file:${pluginPackages.${alias}}" {
      ${perms}}
      "${pluginPackages.${alias}}" {
      ${perms}}
    '')
    (attrNames pluginPermissions)
  );

  homeDir = config.home.homeDirectory;
  permFile =
    if pkgs.stdenv.isDarwin
    then "${homeDir}/Library/Caches/org.Zellij-Contributors.Zellij/permissions.kdl"
    else "\${XDG_CACHE_HOME:-\$HOME/.cache}/zellij/permissions.kdl";
in {
  _module.args.zellijPlugins = {
    inherit barWasm barWidget panedWasm panedAlias barAlias hintsAlias agentsAlias agentManagerAlias agentsWasm;
    inherit recallAlias recallWasm;
    inherit mkWasmPlugin panedPlugin barPlugin hintsPlugin agentsPlugin agentManagerPlugin recallPlugin;
    inherit pluginPermissions pluginPackages permissionsKdl permFile;
  };
}
