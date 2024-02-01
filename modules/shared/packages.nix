{ pkgs }:

with pkgs; [
  # General packages for development and system management
  alacritty
  aspell
  aspellDicts.en
  bash-completion
  bat
  btop
  coreutils
  killall
  neofetch
  neovim
  openssh
  sqlite
  wget
  zip

  # Encryption and security tools
  age
  age-plugin-yubikey
  gnupg
  libfido2
  pinentry

  # Cloud-related tools and SDKs
  docker
  docker-compose
  awscli
  google-cloud-sdk

  # Media-related packages
  dejavu_fonts
  ffmpeg
  fd
  font-awesome
  hack-font
  meslo-lgs-nf

  # Text and terminal utilities
  htop
  iftop
  jetbrains-mono
  jq
  tree
  tmux
  unzip
  zsh-powerlevel10k

  # Python
  python39
  python39Packages.virtualenv # globally install virtualenv
  ansible
  ansible-lint

  # Terraform
  #tfenv
  #terraform-ls
  terraform-docs

  # Nix
  nil
  nixfmt
  statix
  deadnix

]
