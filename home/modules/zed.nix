{pkgs, ...}: {
  programs.zed-editor = {
    enable = false;
    installRemoteServer = false;

    extensions = [
      "catppuccin"
      "nix"
    ];

    extraPackages = [
      pkgs.tofu-ls
    ];

    userSettings = {
      ui_font_family = "MonaspiceNe Nerd Font";
      ui_font_size = 14;
      buffer_font_family = "MonaspiceNe Nerd Font Mono";
      buffer_font_size = 16;
      buffer_line_height = "standard";
      buffer_font_features = {
        calt = true;
        liga = true;
        ss01 = true;
        ss02 = true;
        ss03 = true;
        ss04 = true;
        ss05 = true;
        ss06 = true;
        ss07 = true;
        ss08 = true;
        ss09 = true;
      };
      terminal = {
        copy_on_select = true;
        font_family = "MonaspiceNe Nerd Font Mono";
        font_features = {
          calt = true;
          liga = true;
          ss01 = true;
          ss02 = true;
          ss03 = true;
          ss04 = true;
          ss05 = true;
          ss06 = true;
          ss07 = true;
          ss08 = true;
          ss09 = true;
        };
      };
      agent = {
        dock = "right";
        default_model = {
          provider = "copilot_chat";
          model = "gpt-5-mini";
        };
        model_parameters = [];
      };
      which_key = {
        enabled = true;
      };
      collaboration_panel = {
        dock = "left";
      };
      git_panel = {
        dock = "left";
      };
      agent_servers = {
        claude-acp = {
          type = "registry";
        };
        gemini = {
          type = "registry";
        };
      };
      tabs = {
        show_diagnostics = "all";
      };
      outline_panel = {
        dock = "left";
        button = true;
      };
      project_panel = {
        dock = "left";
        hide_root = true;
        hide_hidden = false;
        entry_spacing = "standard";
        default_width = 180.0;
      };
      search = {
        case_sensitive = false;
      };
      git = {
        blame = {
          show_avatar = false;
        };
      };
      indent_guides = {
        background_coloring = "disabled";
        coloring = "indent_aware";
        active_line_width = 2;
        line_width = 1;
      };
      tab_size = 2;
      minimap = {
        show = "auto";
        thumb = "always";
        thumb_border = "left_open";
      };
      gutter = {
        min_line_number_digits = 0;
        line_numbers = true;
      };
      auto_signature_help = true;
      icon_theme = "Zed (Default)";
      use_system_prompts = false;
      use_system_path_prompts = false;
      on_last_window_closed = "platform_default";
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      vim_mode = true;
      theme = {
        mode = "system";
        light = "Catppuccin Frappé";
        dark = "Catppuccin Mocha";
      };
      auto_install_extensions = {
        catppuccin = true;
        github-actions = true;
        nix = true;
        opentofu = true;
      };
    };
  };
}
