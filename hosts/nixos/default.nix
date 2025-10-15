{
  pkgs,
  user,
  ...
}: let
  keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKoLhJuOE878n9BaTFAAmGgmGjztT61HsMRJOU+uKf/t+pJLxUOn3Or2CLMG5EkfKiTZzLFRQ9y1IvHPvmrM5QB5obJP6mJm2xNlL6wmDBKF0qpcXCU5nX3SmFJdbLg5a4FRWLSdMifWK75kvOSBskTYv81W5ncsbRdHK67AciarHYbkPoktoJpJE4EpEPMrPGLS7AaRo1zfbrIfOJJc4LzX2jBzNg1gw0/iPX39KPB/F+N6DzEh8cd43B3dKlqHscHCerpsHVF0EIgFkGm76MrgoJO92qAjeln9ibVSjU9ysS0YP7Z5khyyd19HQFiMQ6Dvp5cmUxndgvKdHooGE/"
  ];
in {
  imports = [
    ../../modules/nixos/disk-config.nix
    ../../modules/shared/default.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [
      "uinput"
      "tun"
    ];
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 42;
      };
    };
  };

  hardware = {
    enableAllFirmware = true;
    brillo.enable = true; # brightness
    graphics = {
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
  };

  networking = {
    hostName = "luna";
    usePredictableInterfaceNames = true;
    networkmanager.enable = true;
    useDHCP = false;
  };

  nix.gc.dates = "weekly";
  nix.nixPath = ["nixos-config=/home/${user.name}/.local/share/src/nixos-config:/etc/nixos"];

  programs = {
    dconf.enable = true;
    zsh.enable = true;
  };

  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "${pkgs.systemd}/bin/reboot";
            options = ["NOPASSWD"];
          }
        ];
        groups = ["wheel"];
      }
    ];
  };

  services = {
    dbus.enable = true;
    gnome.gnome-keyring.enable = true;
    hardware.bolt.enable = true;
    openssh.enable = true;
    thermald.enable = true;
    upower.enable = true;

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
      settings.default_session = {
        command = "/run/current-system/sw/bin/tuigreet --time --remember --cmd sway";
        user = "greeter";
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  systemd.services = {
    greetd.serviceConfig = {
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      Type = "idle";

      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };

  time.timeZone = "America/Los_Angeles";

  users.users.${user.name} = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = keys;
    extraGroups = [
      "dialout"
      "docker"
      "networkmanager"
      "video"
      "wheel"
    ];
  };

  virtualisation = {
    containers.enable = true;

    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.sway = {
      default = ["gtk"];
      "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
    };
  };

  system.stateVersion = "21.05"; # Don't change this
}
