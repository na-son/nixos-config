{pkgs}:
with pkgs; [
  # General packages for development and system management
  aspell
  aspellDicts.en
  bat
  btop
  coreutils
  openssh
  sqlite
  inetutils
  wget
  zip

  # Font
  nerd-fonts.monaspace

  # Text and terminal utilities
  #htop
  jq
  tree
  unzip
  ripgrep
  gnugrep
  ghostty-bin

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
  nix-tree # $nix-tree .#darwinConfigurations.macos.system
  alejandra
  nh
]
