{
  config,
  pkgs,
  lib,
  user,
  inputs,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
  ];
  home = {
    packages = pkgs.callPackage ./packages.nix {};
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
