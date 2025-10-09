{
  pkgs,
  lib,
  user,
  ...
}:
{
  zsh = {
    enable = true;
    history = {
      append = true; # parallel history until shell exit
      ignoreAllDups = true; # remove previous when duplicate commands run
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
      TFENV_CONFIG_DIR = "$HOME/.local/share/tfenv";
      PATH = "$HOME/.tfenv/bin:$PATH";
    };
  };

  starship = import ./config/starship.nix;

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
    ignores = [
      ".DS_Store"
      ".swp"
      ".vscode"
    ];
    lfs = {
      enable = true;
    };
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
  };

  gh = {
    enable = true;
    gitCredentialHelper.enable = false; # https://github.com/NixOS/nixpkgs/issues/169115
  };

  direnv = {
    enable = true;
    config = {
      global = {
        hide_env_diff = true;
        warn_timeout = 0;
      };
    };
  };

  nvchad = {
    enable = true;
    #extraPlugins = ''
    #  return {
    #    "equalsraf/neovim-gui-shim",lazy=false},
    #    {"lervag/vimtex",lazy=false},
    #    {"nvim-lua/plenary.nvim"},
    #    {
    #      'xeluxee/competitest.nvim',
    #      dependencies = 'MunifTanjim/nui.nvim',
    #      config = function() require('competitest').setup() end,
    #    },
    #}
    #'';
    #extraPackages = with pkgs; [
    #  #nodePackages.bash-language-server
    #  nixd
    #  #(python3.withPackages(ps: with ps; [
    #  #  python-lsp-server
    #  #  flake8
    #  #]))
    #];

    #chadrcConfig = ''
    #  local M = {}

    #  M.base46 = {
    #    theme = "solarized_osaka",
    #  }

    #  M.nvdash = { load_on_startup = true }
    #'';
  };

  #        enableFormat = true;
  #        bash.enable = true;
  #        markdown.enable = true;
  #        nix.enable = true;
  #        python.enable = true;
  #        terraform.enable = true;
  #        yaml.enable = true;

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

  vscode = import ./config/vscode.nix { inherit pkgs; };
}
