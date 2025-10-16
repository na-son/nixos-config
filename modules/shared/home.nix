{
  inputs,
  lib,
  pkgs,
  user,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
    ./config/cachix.nix
    ./config/direnv.nix
    ./config/ghostty.nix
    ./config/git.nix
    ./config/nvf.nix
    ./config/ssh.nix
    ./config/starship.nix
    ./config/vscode.nix
    ./config/zsh.nix
  ];

  home = {
    packages = pkgs.callPackage ./packages.nix {};
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

  #programs = {
  #};
}
