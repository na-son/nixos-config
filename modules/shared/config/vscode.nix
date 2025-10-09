{ pkgs }:
{
  enable = true;
  profiles.default = {
    enableUpdateCheck = false;

    # if extensions are messed up, rm ~/.vscode and build-switch
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      hashicorp.terraform
      #ms-python.python # build issue
      vscodevim.vim
      yzhang.markdown-all-in-one
    ];

    # https://code.visualstudio.com/docs/getstarted/settings#_default-settings
    userSettings = {
      # fonts
      "editor.fontFamily" = "JetBrains Mono";
      "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font Mono";

      # colorscheme
      "workbench.colorTheme" = "Solarized Dark";

      # git
      "diffEditor.ignoreTrimWhitespace" = false;
      "git.confirmSync" = false;

      # terminal behavior
      "terminal.integrated.copyOnSelection" = true;
      "terminal.integrated.defaultProfile.osx" = "zsh";
    };
  };
}
