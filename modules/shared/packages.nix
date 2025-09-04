{ pkgs }:

with pkgs;
[
  # General packages for development and system management
  aspell
  aspellDicts.en
  bat
  btop
  coreutils
  killall
  openssh
  sqlite
  wget
  zip

  # networking
  ipcalc

  # Encryption and security tools
  #age
  #age-plugin-yubikey
  #gnupg
  #libfido2
  #pinentry

  # Cloud-related tools and SDKs
  docker
  docker-compose
  #awscli
  #google-cloud-sdk
  #qemu
  #podman
  #podman-compose
  #podman-tui
  #dive
  #podman-desktop

  # Media-related packages
  dejavu_fonts
  fd
  font-awesome
  jetbrains-mono
  nerd-fonts.jetbrains-mono

  # Text and terminal utilities
  htop
  #iftop
  jq
  tree
  tmux
  unzip
  tio # serial console
  silver-searcher

  # devtools
  direnv
  devenv

  # Python
  python313
  python313Packages.virtualenv # globally install virtualenv
  ansible
  #ansible-lint

  # Terraform
  #terraform-ls
  #terraform-docs

  # Nix
  nil
  nixfmt-rfc-style
  nix-tree # $nix-tree .#darwinConfigurations.macos.system
]
