_: {
  programs.direnv = {
    enable = true;
    config.global = {
      hide_env_diff = true;
      warn_timeout = 0;
    };
  };
}
