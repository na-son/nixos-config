{ config, inputs, pkgs, lib, ... }:

let
  user = "nason";
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOk8iAnIaa1deoc7jw8YACPNVka1ZFJxhnU4G74TmS+p"
  ];
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";

in {
  imports = [
    ../../modules/nixos/disk-config.nix
    ../../modules/shared
    ../../modules/shared/cachix
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 42;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules =
      [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "uinput" "tun" ];
  };

  time.timeZone = "America/Los_Angeles";

  networking = {
    hostName = "luna";
    usePredictableInterfaceNames = true;
    networkmanager.enable = true;
    useDHCP = false;
  };

  nix = {
    nixPath =
      [ "nixos-config=/home/${user}/.local/share/src/nixos-config:/etc/nixos" ];
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      allowed-users = [ "${user}" ];
      auto-optimise-store = true;
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

  };

  programs = {
    dconf.enable = true;
    zsh.enable = true;
  };

  services = {
    dbus.enable = true;
    openssh.enable = true;
    gnome.gnome-keyring.enable = true;
    hardware.bolt.enable = true;
    upower.enable = true;

    thermald.enable = true;

    tlp = {
      enable = true;
      settings = {
        RUNTIME_PM_ON_AC = "auto";
        CPU_ENERGY_PERF_POLICY_ON_AC = "auto";
        DEVICES_TO_DISABLE_ON_LAN_CONNECT = "wifi wwan";
        DEVICES_TO_ENABLE_ON_LAN_DISCONNECT = "wifi wwan";
      };
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${tuigreet} --time --remember --cmd sway";
          user = "greeter";
        };
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  systemd = {
    #packages = [ pkgs.appgate-sdp ];
    services = {
      #appgatedriver.enable = true;

      greetd.serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        StandardOutput = "tty";
        StandardError = "journal"; # Without this errors will spam on screen

        # Without these bootlogs will spam on screen
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
      };
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config = {
      sway = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
  };

  hardware = {
    enableAllFirmware = true;
    brillo.enable = true; # brightness
    opengl = {
      enable = true;
      # intel AV stuff
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-ocl
        intel-vaapi-driver
      ];
    };

    # hardware.nvidia.modesetting.enable = true;
  };

  #  virtualisation = {
  #    docker = {
  #      enable = true;
  #      logDriver = "json-file";
  #    };
  #  };

  users.users = {
    ${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "networkmanager"
        "video" # hotplug devices and thunderbolt
        "dialout" # TTY access
        "docker"
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = keys;
    };

    root = { openssh.authorizedKeys.keys = keys; };
  };

  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [{
        command = "${pkgs.systemd}/bin/reboot";
        options = [ "NOPASSWD" ];
      }];
      groups = [ "wheel" ];
    }];
  };

  fonts.packages = with pkgs; [ dejavu_fonts jetbrains-mono font-awesome ];

  environment.systemPackages = with pkgs; [ gitAndTools.gitFull inetutils ];

  system.stateVersion = "21.05"; # Don't change this
}
