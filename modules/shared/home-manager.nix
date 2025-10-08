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
      font-family = "JetBrainsMono Nerd Font Mono";
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

  #nvf = {
  #  enable = true;
  #  settings = {
  #    vim = {
  #      autocomplete.nvim-cmp.enable = true;
  #      autopairs.nvim-autopairs.enable = true;
  #      comments.comment-nvim.enable = true;
  #      enableLuaLoader = true;
  #      git.gitsigns.enable = true;
  #      mini.tabline.enable = true;
  #      statusline.lualine.enable = true;
  #      vimAlias = true;
  #      filetree.nvimTree = {
  #        enable = true;
  #        mappings.toggle = " t";
  #        setupOpts.hijack_cursor = true;
  #      };
  #      languages = {
  #        enableTreesitter = true;
  #        enableFormat = true;
  #        bash.enable = true;
  #        markdown.enable = true;
  #        nix.enable = true;
  #        python.enable = true;
  #        terraform.enable = true;
  #        yaml.enable = true;
  #      };
  #      lsp = {
  #        enable = true;
  #      };
  #      theme = {
  #        enable = true;
  #        name = "solarized";
  #        style = "dark";
  #      };
  #      clipboard = {
  #        enable = true;
  #        registers = "unnamedplus";
  #      };
  #    };
  #  };
  #};

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

  vscode = {
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
  };
}
