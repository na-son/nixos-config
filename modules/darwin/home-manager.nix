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
  imports = [
    ./dock
  ];

  users.users.${user.name} = {
    name = "${user.name}";
    home = "/Users/${user.name}";
    isHidden = false;
    shell = pkgs.zsh;
  };

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

  local.dock = {
    enable = true;
    entries = [
      { path = "/Applications/Google Chrome.app/"; }
      { path = "/Applications/Ghostty.app/"; }
      { path = "/Applications/Visual Studio Code.app/"; }
      { path = "/Applications/Notion.app/"; }
      {
        path = "/Users/${user.name}/Downloads";
        options = "--display stack --view list";
        section = "others";
      }
      {
        path = "/Users/${user.name}/src";
        options = "--view list";
        section = "others";
      }
    ];
  };

}
