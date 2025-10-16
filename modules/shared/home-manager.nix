{
  pkgs,
  lib,
  user,
  ...
}: {
  ghostty = {
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
      theme = "Solarized Dark Higher Contrast";
      term = "xterm-256color";
    };
  };

  git = {
    enable = true;
    userName = user.fullName;
    userEmail = user.email;
    lfs.enable = true;

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      rebase.autoStash = true;
      safe.directory = "/Users/${user.name}/src/nixos-config";
      core = {
        editor = "nvim";
        autocrlf = "input";
      };
      credential = {
        "https://github.com" = {
          helper = "!gh auth git-credential";
        };
      };
    };

    ignores = [
      ".DS_Store"
      ".swp"
      ".vscode"
    ];
  };

  gh = {
    enable = true;
    gitCredentialHelper.enable = false; # https://github.com/NixOS/nixpkgs/issues/169115
  };

  direnv = {
    enable = true;
    config.global = {
      hide_env_diff = true;
      warn_timeout = 0;
    };
  };

  ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      forwardAgent = false;
      addKeysToAgent = "no";
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };

    extraConfig = lib.mkMerge [
      ''
        Host github.com
          Hostname github.com
          IdentitiesOnly yes
      ''
      (lib.mkIf pkgs.stdenv.hostPlatform.isLinux ''
        IdentityFile /home/${user.name}/.ssh/id_github
      '')
      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin ''
        IdentityFile /Users/${user.name}/.ssh/id_rsa
      '')
    ];
  };

  # nvf = import ./config/nvf.nix {inherit inputs;};
  starship = import ./config/starship.nix;
  vscode = import ./config/vscode.nix {inherit pkgs;};
  zsh = import ./config/zsh.nix;
}
