{
  inputs,
  lib,
  pkgs,
  user,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
    ./modules/cachix.nix
    ./modules/direnv.nix
    ./modules/ghostty.nix
    ./modules/git.nix
    ./modules/nvf.nix
    ./modules/ssh.nix
    ./modules/starship.nix
    ./modules/sway.nix
    ./modules/vscode.nix
    ./modules/zsh.nix
    ./packages.nix
  ];

  home = {
    username = "${user.name}";

    homeDirectory = lib.mkDefault (
      if pkgs.stdenv.isLinux
      then "/home/${user.name}"
      else "/Users/${user.name}"
    );

    keyboard = {
      layout = "us";
      variant = "dvorak";
    };

    stateVersion = "23.11";
  };

  manual.manpages.enable = false;

  #programs = { };
}
