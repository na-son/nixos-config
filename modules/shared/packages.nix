{ pkgs }:

with pkgs; [
  # General packages for development and system management
  aspell
  aspellDicts.en
  bash-completion
  bat
  btop
  coreutils
  killall
  neovim
  openssh
  sqlite
  wget
  zip

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

  # Media-related packages
  dejavu_fonts
  ffmpeg
  fd
  font-awesome
  jetbrains-mono

  # Text and terminal utilities
  htop
  iftop
  jq
  tree
  tmux
  unzip
  zsh-powerlevel10k
  tio # serial console
  silver-searcher

  # Python
  python39
  #python39Packages.virtualenv # globally install virtualenv
  #ansible
  #ansible-lint

  # Terraform
  terraform
  #tfenv
  terraform-ls
  terraform-docs

  # virtual machines
  qemu
  libvirt
  virt-manager

  # Nix
  nil
  nixfmt
  #statix
  #deadnix

]
