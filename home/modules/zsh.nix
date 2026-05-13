_: {
  programs.zsh = {
    enable = true;
    history = {
      append = true;
      ignoreAllDups = true;
      ignorePatterns = [
        "cd"
        "ls"
        "pwd"
      ];
    };

    shellAliases = {
      cat = "bat";
      ls = "ls --color=auto";
    };

    sessionVariables = {
      EDITOR = "nvim";

      # tfenv stuff
      PATH = "$HOME/.local/bin:$HOME/.tfenv/bin:$PATH";

      TFENV_CONFIG_DIR = "$HOME/.local/share/tfenv";
    };
  };
}
