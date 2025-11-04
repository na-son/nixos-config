{user, ...}: {
  imports = [
    ../default.nix
  ];

  # it's just way less stuff to manage
  documentation = {
    enable = false;
    doc.enable = false;
    info.enable = false;
    man.enable = false;
  };

  homebrew = {
    enable = true;
    casks = [
      "zoc"
      "zoom"
      "notion"
      "google-chrome"
      "meetingbar"
      "hiddenbar"
    ];
  };

  nix.gc.interval = {
    Weekday = 0;
    Hour = 2;
    Minute = 0;
  };

  programs.man.enable = false;
  programs.info.enable = false;

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    stateVersion = 4;

    checks.verifyNixPath = false;
    primaryUser = user.name;
    tools.darwin-option.enable = false;

    # https://mynixos.com/nix-darwin/options/system.defaults
    defaults = {
      CustomUserPreferences = {
        "com.apple.Spotlight" = {
          "com.apple.Spotlight MenuItemHidden" = 1;
        };
      };

      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;
        AppleICUForce24HourTime = true;

        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;

        KeyRepeat = 2; # 120, 90, 60, 30, 12, 6, 2
        InitialKeyRepeat = 15; # 120, 94, 68, 35, 25, 15

        # unavailable preferences can be accessed using quotes
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = true;
        expose-animation-duration = 0.0;
        launchanim = true;
        mru-spaces = false;
        orientation = "bottom";
        show-recents = false;
        tilesize = 48;

        # dockutil -L is useful here, apps can have spaces in path but files need %20
        persistent-apps = [
          {
            app = "/Applications/Google Chrome.app";
          }
          {
            app = "/Users/${user.name}/Applications/Home Manager Apps/Ghostty.app";
          }
          {
            app = "/Users/${user.name}/Applications/Home Manager Apps/Visual Studio Code.app";
          }
          {
            spacer = {
              small = true;
            };
          }
          {
            folder = "/Users/${user.name}/src";
          }
          {
            folder = "/Users/${user.name}/Downloads";
          }
        ];
      };

      finder = {
        _FXShowPosixPathInTitle = true;
        AppleShowAllExtensions = true;
        ShowPathbar = true;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };

  users.users.${user.name} = {
    isHidden = false;
  };
}
