{
  lib,
  pkgs,
  ...
}: {
  gtk = {
    enable = true && pkgs.stdenv.isLinux;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-icon-theme;
    };
    iconTheme = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-icon-theme;
    };
  };

  # notifications
  services.mako = {
    enable = true && pkgs.stdenv.isLinux;
    settings = {
      default-timeout = 10000;
    };
  };

  wayland.windowManager.sway = {
    enable = true && pkgs.stdenv.isLinux;
    config = rec {
      modifier = "Mod4";
      terminal = "ghostty";
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
        {command = "exec --no-startup-id gnome-keyring-daemon --start --components=pkcs11,secrets,ssh";}
        {command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";}
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
            names = ["JetBrains Mono"];
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
}
