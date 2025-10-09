{
  config,
  pkgs,
  user,
  inputs,
  ...
}:

let
  sharedFiles = import ../shared/files.nix { inherit config pkgs user; };
  additionalFiles = import ./files.nix { inherit config pkgs user; };
in
{
  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix { };
    masApps = { }; # $ mas search <app name>
  };

  home-manager = {
    useGlobalPkgs = true;
    users.${user.name} =
      {
        pkgs,
        config,
        lib,
        inputs,
        ...
      }:
      {
        imports = [
          inputs.nix4nvchad.homeManagerModule
        ];
        home = {
          packages = pkgs.callPackage ./packages.nix { };
          file = lib.mkMerge [
            sharedFiles
            additionalFiles
          ];
          stateVersion = "23.11";
        };
        programs =
          { }
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
      };
  };

}
