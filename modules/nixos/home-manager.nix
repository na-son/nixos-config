{
  config,
  pkgs,
  lib,
  user,
  inputs,
  ...
}:

let
  #xdg_configHome = "/home/${user}/.config";
  shared-programs = import ../shared/home-manager.nix {
    inherit
      config
      pkgs
      lib
      user
      inputs
      ;
  };
  shared-files = import ../shared/files.nix { inherit config pkgs user; };
in
{
  imports = [
    inputs.nix4nvchad.homeManagerModule
  ];
  home = {
    enableNixpkgsReleaseCheck = false;
    username = "${user.name}";
    homeDirectory = "/home/${user.name}";
    packages = pkgs.callPackage ./packages.nix { };
    file = shared-files // import ./files.nix { inherit user; };
    stateVersion = "21.05";

    keyboard = {
      layout = "us";
      variant = "dvorak";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-icon-theme;
    };
    iconTheme = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-icon-theme;
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      #terminal = "foot";
      menu = "rofi -show run";
      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_variant = "dvorak";
          xkb_options = "ctrl:nocaps";
          repeat_delay = "300";
          repeat_rate = "50";
        };
        "type:touchpad" = {
          tap = "enabled";
          dwt = "enabled";
          natural_scroll = "enabled";
          accel_profile = "adaptive"; # mouse acceleration
          pointer_accel = "0.3";
        };
      };
      startup = [
        { command = "exec --no-startup-id gnome-keyring-daemon --start --components=pkcs11,secrets,ssh"; }
        { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
        {
          # see https://nixos.wiki/wiki/Firefox
          always = true;
          command = "systemctl --user import-environment";
        }
        #{
        #  always = true;
        #  command = "${dbus-sway-environment}/bin/dbus-sway-environment";
        #}
      ];

      keybindings = lib.mkOptionDefault {

        # Laptop buttons
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        "XF86MonBrightnessDown" = "exec brillo -q -U 5";
        "XF86MonBrightnessUp" = "exec brillo -q -A 5";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";
        "Mod4+Shift+W" = "kill";
      };

      gaps = {
        inner = 10;
        outer = 10;
        smartGaps = true;
      };

      bars = [
        {
          fonts = {
            names = [ "JetBrains Mono" ];
            size = 10.0;
          };
          mode = "dock";
          hiddenState = "hide";
          position = "bottom";
          statusCommand = "${pkgs.i3status}/bin/i3status";
          workspaceButtons = true;
          trayOutput = "primary";
        }
      ];
    };
  };

  services = {
    # notifications
    mako = {
      enable = true;
      settings = {
        default-timeout = 10000;
      };
    };

    # Automount
    # udiskie.enable = true;
  };

  programs = shared-programs // {
    # terminal
    foot = {
      enable = true;
      server.enable = true;

      settings = {
        main = {
          term = "xterm-256color";
          font = "JetBrains Mono:size=8";
          dpi-aware = "yes";
          pad = "10x10 center";
        };

        bell = {
          urgent = "yes";
          notify = "yes";
          visual = "yes";
        };

        mouse = {
          hide-when-typing = "yes";
        };

        colors = {
          background = "002b36";
          foreground = "839496";

          regular0 = "073642";
          regular1 = "dc322f";
          regular2 = "859900";
          regular3 = "b58900";
          regular4 = "268bd2";
          regular5 = "d33682";
          regular6 = "2aa198";
          regular7 = "eee8d5";
          bright0 = "002b36";
          bright1 = "cb4b16";
          bright2 = "586e75";
          bright3 = "657b83";
          bright4 = "839496";
          bright5 = "6c71c4";
          bright6 = "93a1a1";
          bright7 = "fdf6e3";

          selection-foreground = "93a1a1";
          selection-background = "073642";
        };
      };
    };
  };
}
