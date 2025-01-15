{ config, pkgs, ... }:

let
  user = "casazza";
  keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGXhLS4tLWrsiiKhoYh7CxhOmhcwukzbE27OTy5fUvLpM6bQ0jCUW8w5nYuvzhEgyNPlPi2iu04j+qUUp8fxu3Lkw3WKvHF6G/Nv/yEeQgdffO4Ulw2Qu2WluFkIkedsY8sBA2zqcFrqdp+L64JRJySy1kx/xJbzNMIrY2Q/DI212FHP3peeWSvofz7tIrOdJ/6TP3nj89vuOLHnMqBG3/tHb13/4s/DKciPlX12doG2S8PaQMifrIiCPmT3te5+IGTLyyusdGLmPsoyCCgN6hgQKq3dTOdiniMpmIKFKH7egdi5e4TU0KYKjzfvMhNnv0hUKnx8Q1izwzIUk/XyzDid2ZUvAuSJSBs0uQC64zHjkARg+7tCrJ7CGbxhOnjtUTRLZ2jxYd/hZn4Mnc4CRf9hRvZwf/CCqOhyphntdzRmWnmOh3SaEOlFHG1debP8Q8CAX1mw5A4mYddGsZUg1IqygHv2TS1R8RTNhIWIIW9lVoojYAH2PSVaQu5yp8h7qbTUybF59F8VpzA6kfojUHvTx5EebbRPytxhyAGBvB7l0hr/pWih704SgwDixh9UYqJnpiC9wy0WGWc3M8HG5j2Q45AgHSr2bYSR69XJ614Tj9+myeYIvaUFcZGw4twxa54aK9ReTjQ5zFXgXiBVVGQS0SL8uKq+3Xg3DrVIIDyQ== olive.casazza@schrodinger.com"
  ];
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
in
{
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
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [
      "uinput"
      "tun"
    ];
  };

  time.timeZone = "America/Los_Angeles";

  networking = {
    hostName = "luna";
    usePredictableInterfaceNames = true;
    networkmanager.enable = true;
    useDHCP = false;
  };

  nix = {
    nixPath = [ "nixos-config=/home/${user}/.local/share/src/nixos-config:/etc/nixos" ];
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      allowed-users = [ "${user}" ];
      auto-optimise-store = true;
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
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
    services = {
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

  virtualisation = {
    containers.enable = true;
    
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

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

    root = {
      openssh.authorizedKeys.keys = keys;
    };
  };

  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "${pkgs.systemd}/bin/reboot";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
  };

  fonts.packages = with pkgs; [
    dejavu_fonts
    jetbrains-mono
    font-awesome
  ];

  environment.systemPackages = with pkgs; [
    gitAndTools.gitFull
    inetutils
  ];

  system.stateVersion = "21.05"; # Don't change this
}
