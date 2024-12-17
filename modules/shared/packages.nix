{ pkgs }:

with pkgs;
[
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

  # networking
  ipcalc

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
  #qemu
  #podman
  #podman-compose
  #podman-tui
  #dive
  #podman-desktop
  google-cloud-sdk

  # Media-related packages
  dejavu_fonts
  ffmpeg
  fd
  font-awesome
  jetbrains-mono
  (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

  # Text and terminal utilities
  htop
  #iftop
  jq
  tree
  tmux
  unzip
  zsh-powerlevel10k
  tio # serial console
  silver-searcher
  fastfetch

  # devtools
  direnv
  devenv

  # Python
  python311
  python311Packages.virtualenv # globally install virtualenv
  #ansible
  #ansible-lint

  # Terraform
  #terraform-ls
  #terraform-docs

  # Nix
  nil
  nixfmt-rfc-style
]
