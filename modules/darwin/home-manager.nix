{ config, pkgs, lib, home-manager, ... }:

let
  user = "nason";
  # Define the content of your file as a derivation
  myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
    #!/bin/sh
    emacsclient -c -n &
  '';
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  imports = [
   ./dock
  ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix {};

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    masApps = {
     # "1password" = 1333542190;
    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }:{
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        file = lib.mkMerge [
          sharedFiles
          additionalFiles
         # { "emacs-launcher.command".source = myEmacsLauncher; }
        ];
        stateVersion = "23.11";
      };
      programs = {} // import ../shared/home-manager.nix { inherit config pkgs lib; };

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;
    };
  };

  # Fully declarative dock using the latest from Nix Store
  local.dock.enable = true;
  local.dock.entries = [
    { path = "/Applications/Google Chrome.app/"; }
    { path = "/Applications/iTerm.app/"; }
    #{ path = "${pkgs.alacritty}/Applications/Alacritty.app/"; }
    { path = "/System/Applications/Messages.app/"; }
   # {
   #   path = toString myEmacsLauncher;
   #   section = "others";
   # }
   # {
   #   path = "${config.users.users.${user}.home}/.local/share/";
   #   section = "others";
   #   options = "--sort name --view grid --display folder";
   # }
   # {
   #   path = "${config.users.users.${user}.home}/.local/share/downloads";
   #   section = "others";
   #   options = "--sort name --view grid --display stack";
   # }
  ];

}
