{
  config,
  pkgs,
  lib,
  user,
  inputs,
  ...
}: let
  sharedFiles = import ../shared/files.nix {inherit config pkgs user;};
  additionalFiles = import ./files.nix {inherit config pkgs user;};
in {
  imports = [
    inputs.nvf.homeManagerModules.default
  ];
  home = {
    packages = pkgs.callPackage ./packages.nix {};
    #file = sharedFiles // additionalFiles;
    stateVersion = "23.11";
  };
  programs =
    {}
    // import ../shared/home-manager.nix {
      inherit
        config
        pkgs
        lib
        user
        inputs
        ;
    };

  manual.manpages.enable = false;
}
