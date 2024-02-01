{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; }; in
shared-packages ++ [

  # Hardware
  pciutils

  # Security and authentication
  yubikey-agent

  # App and package management
  appimage-run
  gnumake
  cmake
  home-manager

  # Media and design tools
  vlc
  fontconfig
  font-manager

  # Audio tools
  cava # Terminal audio visualizer
  pavucontrol # Pulse audio controls

  # Testing and development tools
  direnv
  rofi
  rofi-calc
  rnix-lsp # lsp-mode for nix

  # Screenshot and recording tools
  flameshot

  # Text and terminal utilities
  tree
  unixtools.ifconfig
  unixtools.netstat
  xclip # For the org-download package in Emacs
  xorg.xwininfo # Provides a cursor to click and learn about windows
  xorg.xrandr

  # File and system utilities
  inotify-tools # inotifywait, inotifywatch - For file system events
  i3lock-fancy-rapid
  libnotify
  pcmanfm # File browser
  sqlite
  xdg-utils

  # Other utilities
  yad # yad-calendar is used with polybar
  xdotool
  google-chrome

  # PDF viewer
  zathura

  # Music and entertainment
  spotify
]
