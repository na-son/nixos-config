_: {
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        autocomplete.blink-cmp.enable = true;
        autopairs.nvim-autopairs.enable = true;
        comments.comment-nvim.enable = true;
        enableLuaLoader = true;
        mini.tabline.enable = true;
        options.tabstop = 2;
        options.shiftwidth = 2;
        telescope.enable = true;
        treesitter.context.enable = true;
        vimAlias = true;

        binds = {
          cheatsheet.enable = true;
          whichKey.enable = true;
        };

        git = {
          enable = true;
          neogit.enable = true;
          gitsigns.enable = true;
          #gitsigns.codeActions.enable = false; # throws an annoying debug message
        };

        filetree.neo-tree = {
          enable = true;
          setupOpts = {
            close_if_last_window = true;
            enable_cursor_hijack = true;
          };
        };

        languages = {
          enableExtraDiagnostics = true;
          enableFormat = true;
          enableTreesitter = true;

          # bash.enable = true;
          # markdown.enable = true;
          nix.enable = true;
          # python.enable = true;
          # terraform.enable = true;
          # yaml.enable = true;
        };

        lsp = {
          enable = true;
          formatOnSave = true;
        };

        keymaps = [
          {
            desc = "Leave Terminal";
            key = "<Esc><Esc>";
            action = "<C-\\><C-N>";
            mode = "t";
            silent = true;
          }
          {
            desc = "open tree";
            key = "<leader>e";
            action = "<cmd>Neotree<CR>";
            mode = "n";
            silent = true;
          }
          {
            desc = "whichkey";
            key = "<leader>wk";
            action = "<cmd>WhichKey <CR>";
            mode = "n";
            silent = true;
          }
        ];

        statusline.lualine = {
          enable = true;
          theme = "auto";
        };

        terminal.toggleterm = {
          enable = true;
          lazygit.enable = true;
        };

        theme = {
          enable = true;
          name = "solarized";
          style = "dark";
        };

        ui = {
          borders.enable = true;
          colorizer.enable = true;
          fastaction.enable = true;
          illuminate.enable = true;
          noice.enable = true;
          smartcolumn.enable = true;
          breadcrumbs = {
            enable = true;
            #navbuddy.enable = true;
          };
        };

        visuals = {
          fidget-nvim.enable = true;
          highlight-undo.enable = true;
          indent-blankline.enable = true;
          nvim-cursorline.enable = true;
          nvim-scrollbar.enable = true;
          nvim-web-devicons.enable = true;
          cinnamon-nvim = {
            enable = true;
            setupOpts = {
              keymaps.basic = true;
              keymaps.extra = true;
            };
          };
        };
      };
    };
  };
}
