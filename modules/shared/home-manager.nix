{ config, pkgs, lib, ... }:

let
  name = "Austin Nason";
  user = "nason";
  email = "austin.nason@schrodinger.com";
in {
  # Shared shell configuration
  zsh = {
    enable = true;
    autocd = false;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./config;
        file = "p10k.zsh";
      }
    ];

    initExtraFirst = ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      export PATH=$HOME/.local/share/bin:$PATH
      export PATH=$HOME/.tfenv/bin:$PATH
      export HISTIGNORE="pwd:ls:cd"

      export EDITOR="nvim"
      export TFENV_CONFIG_DIR=$HOME/.local/share/tfenv

      # nix shortcuts
      shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }

      alias diff=difft
      alias ls='ls --color=auto'

      eval "$(direnv hook zsh)"

    '';
  };

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    userName = name;
    userEmail = email;
    lfs = { enable = true; };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "nvim";
        autocrlf = "input";
      };
      pull.rebase = true;
      rebase.autoStash = true;
      credential = {
        "https://github.com" = { helper = "!gh auth git-credential"; };
      };
    };
  };

  gh = {
    enable = true;
    gitCredentialHelper.enable =
      false; # https://github.com/NixOS/nixpkgs/issues/169115
  };

  vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-airline-themes
      vim-startify
      vim-tmux-navigator
    ];
    settings = { ignorecase = true; };
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

  #firefox = {
  #  enable = true;
  #  #nativeMessagingHosts.packages = [
  #  #  pkgs.tridactyl-native
  #  #];
  #  profiles = {
  #    default = {
  #      id = 0;
  #      name = "default";
  #      isDefault = true;
  #        #extensions = with pkgs.nur.repos.rycee.firefox-addons; [
  #        #  no-pdf-download
  #        #  tridactyl
  #        #  ublock-origin
  #        #];
  #      settings = {
  #        "gfx.webrender.all" = true; # gpu accel
  #        "media.ffmpeg.vaapi.enabled" = true;
  #        "widget.dmabuf.force-enabled" = true;

  #        "privacy.webrtc.legacyGlobalIndicator" = false;
  #        "app.shield.optoutstudies.enabled" = false;
  #        "app.update.auto" = false;
  #        "browser.bookmarks.restore_default_bookmarks" = false;
  #        "browser.contentblocking.category" = "strict";
  #        "browser.ctrlTab.recentlyUsedOrder" = false;
  #        "browser.discovery.enabled" = false;
  #        "browser.laterrun.enabled" = false;
  #        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" =
  #          false;
  #        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" =
  #          false;
  #        "browser.newtabpage.activity-stream.feeds.snippets" = false;
  #        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" =
  #          "";
  #        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" =
  #          "";
  #        "browser.newtabpage.activity-stream.section.highlights.includePocket" =
  #          false;
  #        "browser.newtabpage.activity-stream.showSponsored" = false;
  #        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
  #        "browser.newtabpage.pinned" = false;
  #        "browser.protections_panel.infoMessage.seen" = true;
  #        "browser.quitShortcut.disabled" = true;
  #        "browser.shell.checkDefaultBrowser" = false;
  #        "browser.ssb.enabled" = true;
  #        "browser.toolbars.bookmarks.visibility" = "never";
  #        "browser.urlbar.placeholderName" = "DuckDuckGo";
  #        "browser.urlbar.suggest.openpage" = false;
  #        "datareporting.policy.dataSubmissionEnable" = false;
  #        "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;
  #        "dom.security.https_only_mode" = true;
  #        "dom.security.https_only_mode_ever_enabled" = true;
  #        "extensions.getAddons.showPane" = false;
  #        "extensions.htmlaboutaddons.recommendations.enabled" = false;
  #        "extensions.pocket.enabled" = false;
  #        "identity.fxaccounts.enabled" = false;
  #        "privacy.trackingprotection.enabled" = true;
  #        "privacy.trackingprotection.socialtracking.enabled" = true;
  #      };
  #    };
  #  };

  #};

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
    extensions = with pkgs.vscode-extensions; [
      hashicorp.terraform
      bbenoist.nix
      vscodevim.vim
      yzhang.markdown-all-in-one
    ];
    userSettings = {
      "editor.fontFamily" = "JetBrains Mono";
      "diffEditor.ignoreTrimWhitespace" = false;
      "terminal.integrated.copyOnSelection" = true;
      "terminal.integrated.defaultProfile.osx" = "zsh";
      "workbench.colorTheme" = "Solarized Dark";
    };
  };
}
