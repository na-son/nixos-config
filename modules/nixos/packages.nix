{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; };
in shared-packages ++ [

  # Security and authentication
  yubikey-agent

  # App and package management
  gnumake
  cmake
  home-manager

  # Media and design tools
  fontconfig
  font-manager

  # Audio tools
  pavucontrol # Pulse audio controls

  neovim

  # MISC DE / WM
  mako
  foot

  wl-clipboard
  cliphist

  rofi
  rofi-calc

  # Testing and development tools
  direnv

  # Core unix tools
  unixtools.ifconfig
  unixtools.netstat
  pciutils
  inotify-tools
  libnotify
  greetd.tuigreet

  sqlite
  xdg-utils
  xdg-user-dirs
  xdg-desktop-portal-wlr
  xdg-desktop-portal-gtk

  # work
  appgate-sdp
  dnsmasq
]
