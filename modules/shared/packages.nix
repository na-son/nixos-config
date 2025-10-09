{ pkgs }:

with pkgs;
[
  # General packages for development and system management
  aspell
  aspellDicts.en
  bat
  btop
  coreutils
  openssh
  sqlite
  wget
  zip

  # networking
  #ipcalc

  # Encryption and security tools
  #age
  #age-plugin-yubikey
  #gnupg
  #libfido2
  #pinentry

  # Cloud-related tools and SDKs
  #docker
  #docker-compose
  #awscli
  #google-cloud-sdk
  #qemu
  #podman
  #podman-compose
  #podman-tui
  #dive
  #podman-desktop

  # Media-related packages
  #fd
  jetbrains-mono
  nerd-fonts.jetbrains-mono
  nerd-fonts.monaspace

  # Text and terminal utilities
  #htop
  #iftop
  jq
  tree
  #tmux
  unzip
  tio # serial console
  ripgrep

  # devtools
  direnv
  devenv

  # Python
  #python313
  #python313Packages.virtualenv # globally install virtualenv
  #ansible
  #ansible-lint

  # Nix
  nil
  nixfmt-rfc-style
  nix-tree # $nix-tree .#darwinConfigurations.macos.system
  nh
]
