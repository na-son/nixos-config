{
  enable = true;
  enableZshIntegration = true;

  # TOML mappings from https://starship.rs/config
  settings = {
    add_newline = true;
    scan_timeout = 10;
    aws.disabled = true;
    gcloud.disabled = true;

    fill.symbol = " ";
    format = "($nix_shell$container$fill$git_metrics\n)$cmd_duration$hostname$shlvl$shell$env_var$jobs$sudo$username$character";
    right_format = "$directory$vcsh$git_branch$git_commit$git_state$git_status$cmake$python$conda$terraform$rust$memory_usage$custom$status$os$battery$time";
    continuation_prompt = "[▸▹ ](dimmed white)";

    cmd_duration = {
      format = "[$duration](bold yellow)";
    };

    git_branch = {
      symbol = "[△](bold italic bright-blue)";
      format = " [$branch(:$remote_branch)]($style)";
      style = "italic bright-blue";

      only_attached = true;
      truncation_length = 11;
      truncation_symbol = "⋯";
      ignore_branches = [
        "main"
      ];
    };

    git_metrics = {
      disabled = false;
      format = "([+$added](italic dimmed green))([-$deleted](italic dimmed red))";

      ignore_submodules = true;
    };

    git_status = {
      format = "([⎪$ahead_behind$staged$modified$untracked$renamed$deleted$conflicted$stashed⎥]($style))";
      style = "bold dimmed blue";

      ahead = "[▴$count](italic green)|";
      behind = "[▿$count](italic red)|";
      conflicted = "[◪◦](italic bright-magenta)";
      deleted = "[✕](italic red)";
      diverged = "[◇ ▴┤[$ahead_count](regular white)│▿┤[$behind_count](regular white)│](italic bright-magenta)";
      modified = "[●◦](italic yellow)";
      renamed = "[◎◦](italic bright-blue)";
      staged = "[▪┤[$count](bold white)│](italic bright-cyan)";
      stashed = "[◃◈](italic white)";
      untracked = "[◌◦](italic bright-yellow)";
    };

    nix_shell = {
      symbol = "❄";
      format = "[*⎪$state⎪](bold dimmed blue) [$name](italic dimmed white)";

      impure_msg = "[⌽](bold dimmed red)";
      unknown_msg = "[◌](bold dimmed yellow)";
      pure_msg = "[⌾](bold dimmed green)";
    };

    terraform = {
      format = "[🌎⎪$workspace⎪](bold dimmed purple)";
    };
  };
}
