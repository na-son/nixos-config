{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;

    settings = {
      copy-on-select = true;
      clipboard-paste-protection = false;
      cursor-style = "block";
      font-size = 18;
      font-family = "MonaspiceNe Nerd Font Mono";
      font-feature = "calt, liga, ss01, ss02, ss03, ss04, ss05, ss06, ss07, ss08, ss09";
      macos-titlebar-proxy-icon = "hidden";
      shell-integration-features = "no-cursor";
      theme = "Catppuccin Mocha";
      term = "xterm-256color";
    };
  };
}
