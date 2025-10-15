{
  pkgs,
  lib,
  user,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
  ];
  home = {
    packages = pkgs.callPackage ./packages.nix {};
    #file = import ../shared/files.nix {inherit config pkgs user;};
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
