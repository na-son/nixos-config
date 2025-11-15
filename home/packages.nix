{pkgs, ...}: let
  commonPackages = with pkgs; [
    # General packages for development and system management
    bat
    coreutils
    openssh

    # Font
    nerd-fonts.monaspace

    # Text and terminal utilities
    jq
    tree
    ripgrep
    ghostty-bin

    # devtools
    direnv
    devenv

    # Nix
    nil
    nixd
    nix-tree # $nix-tree .#darwinConfigurations.macos.system
    alejandra
    nh
    home-manager

    # testing
    gemini-cli-bin
  ];

  linuxOnlyPackages = with pkgs; [
    # Core unix tools
    pciutils
    inotify-tools
    libnotify
    tuigreet

    # Media and design tools
    fontconfig
    font-manager

    # Pulseaudio
    pavucontrol

    wl-clipboard
    cliphist

    rofi
    rofi-calc

    # xdg bits
    xdg-utils
    xdg-user-dirs
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
  ];

  darwinOnlyPackages = with pkgs; [
    gnugrep
  ];
in {
  home.packages =
    commonPackages
    ++ (
      if pkgs.stdenv.isLinux
      then linuxOnlyPackages
      else []
    )
    ++ (
      if pkgs.stdenv.isDarwin
      then darwinOnlyPackages
      else []
    );
}
