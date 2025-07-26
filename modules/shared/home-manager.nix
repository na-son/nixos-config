{ pkgs, lib, ... }:

let
  name = "Austin Nason";
  user = "nason";
  email = "austin.nason@schrodinger.com";
in
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

  starship = {
    enable = true;
    enableZshIntegration = true;

    # these are TOML mappings from https://starship.rs/config
    settings = {
      add_newline = true;
      scan_timeout = 10;

      fill.symbol = " ";
      format = "($nix_shell$container$fill$git_metrics\n)$cmd_duration$hostname$localip$shlvl$shell$env_var$jobs$sudo$username$character";
      right_format = "$directory$vcsh$git_branch$git_commit$git_state$git_status$docker_context$cmake$python$conda$terraform$rust$memory_usage$custom$status$os$battery$time";
      continuation_prompt = "[▸▹ ](dimmed white)";
      
      aws.disabled = true;
      gcloud.disabled = true;

      cmd_duration = {
        format = "[$duration](bold yellow)";
      };

      git_branch = {
        style = "italic bright-blue";
        format = " [$branch(:$remote_branch)]($style)";
        
        symbol = "[△](bold italic bright-blue)";
        only_attached = true;
        truncation_symbol = "⋯";
        truncation_length = 11;
        ignore_branches = [
          "main"
        ];
      };

      git_metrics = {
        format = "([+$added](italic dimmed green))([-$deleted](italic dimmed red))";
        
        ignore_submodules = true;
        disabled = false;
      };

      git_status = {
        style = "bold dimmed blue";
        format = "([⎪$ahead_behind$staged$modified$untracked$renamed$deleted$conflicted$stashed⎥]($style))";
        conflicted = "[◪◦](italic bright-magenta)";
        ahead = "[▴$count](italic green)|";
        behind = "[▿$count](italic red)|";
        diverged = "[◇ ▴┤[$ahead_count](regular white)│▿┤[$behind_count](regular white)│](italic bright-magenta)";
        untracked = "[◌◦](italic bright-yellow)";
        stashed = "[◃◈](italic white)";
        modified = "[●◦](italic yellow)";
        staged = "[▪┤[$count](bold white)│](italic bright-cyan)";
        renamed = "[◎◦](italic bright-blue)";
        deleted = "[✕](italic red)";
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
  };

  ghostty = {
    enable = true;
    package = null;
    settings = {
      font-size = 18;
      font-family = "JetBrainsMono Nerd Font Mono";
      theme = "Solarized Dark Higher Contrast";
      cursor-style = "block";
      shell-integration-features = "no-cursor";
      clipboard-paste-protection = false;
      copy-on-select = true;
      term = "xterm-256color";

      macos-titlebar-proxy-icon = "hidden";

      config-file = "~/.config/ghostty/extra"; # for testing shaders atm
    };
  };
      # custom-shader = "";

  git = {
    enable = true;
    ignores = [
      ".DS_Store"
      ".swp"
      ".vscode"
    ];
    userName = name;
    userEmail = email;
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "nvim";
        autocrlf = "input";
      };
      pull.rebase = true;
      rebase.autoStash = true;
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

  vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-airline-themes
      vim-startify
      vim-tmux-navigator
    ];
    settings = {
      ignorecase = true;
    };
    extraConfig = ''
      "" General
      set number
      set history=1000
      set nocompatible
      set modelines=0
      set encoding=utf-8
      set scrolloff=3
      set showmode
      set showcmd
      set hidden
      set wildmenu
      set wildmode=list:longest
      set cursorline
      set ttyfast
      set nowrap
      set ruler
      set backspace=indent,eol,start
      set laststatus=2
      set clipboard=autoselect

      " Dir stuff
      set nobackup
      set nowritebackup
      set noswapfile
      set backupdir=~/.config/vim/backups
      set directory=~/.config/vim/swap

      "" Whitespace rules
      set tabstop=8
      set shiftwidth=2
      set softtabstop=2
      set expandtab

      "" Searching
      set incsearch
      set gdefault

      "" Statusbar
      set nocompatible " Disable vi-compatibility
      set laststatus=2 " Always show the statusline
      let g:airline_theme='seoul256'
      let g:airline_powerline_fonts = 1

      "" Local keys and such
      let mapleader=","
      let maplocalleader=" "

      "" Change cursor on mode
      :autocmd InsertEnter * set cul
      :autocmd InsertLeave * set nocul

      "" File-type highlighting and configuration
      syntax on
      filetype on
      filetype plugin on
      filetype indent on

      "" Paste from clipboard
      nnoremap <Leader>, "+gP

      "" Copy from clipboard
      xnoremap <Leader>. "+y

      "" Move cursor by display lines when wrapping
      nnoremap j gj
      nnoremap k gk

      "" Map leader-q to quit out of window
      nnoremap <leader>q :q<cr>

      "" Move around split
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l

      "" Easier to yank entire line
      nnoremap Y y$

      "" Move buffers
      nnoremap <tab> :bnext<cr>
      nnoremap <S-tab> :bprev<cr>

      let g:startify_lists = [
        \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      }
        \ ]

      let g:startify_bookmarks = [
        \ '~/.local/share/src',
        \ ]

      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1
    '';
  };

  ssh = {
    enable = true;
    extraConfig = lib.mkMerge [
      ''
        Host github.com
          Hostname github.com
          IdentitiesOnly yes
      ''
      (lib.mkIf pkgs.stdenv.hostPlatform.isLinux ''
        IdentityFile /home/${user}/.ssh/id_github
      '')
      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin ''
        IdentityFile /Users/${user}/.ssh/id_rsa
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
        ms-python.python
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
