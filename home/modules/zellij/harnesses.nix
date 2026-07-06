{...}: let
  # Agent harnesses exposed to the `agents`/`agent_manager` plugins. Vendored
  # from zpak, but rewired to a static list: this config's agent CLIs come from
  # `sdgr-hm` (claude, gemini), `programs.codex`, and `programs.opencode` rather
  # than zpak's `llm-agents` program modules, so detecting them via
  # `config.programs.<harness>.enable` would reference options that don't exist
  # here. Edit this list if the available agent CLIs change.
  harnessesList = ["claude" "codex" "gemini" "opencode"];
  harnessesStr = "claude,codex,gemini,opencode";
  harnessCommands = {
    harness_claude_command = "claude";
    harness_claude_resume_command = "claude --resume {session_id}";
    harness_codex_command = "codex";
    harness_codex_resume_command = "codex resume {session_id}";
    harness_gemini_command = "gemini";
    harness_opencode_command = "opencode";
  };
in {
  _module.args.zellijHarnesses = {
    inherit harnessesList harnessesStr harnessCommands;
  };
}
