{
  config,
  pkgs,
  home-manager,
  ...
}:

let
  user = "nason";
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  imports = [ ./dock ];

  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
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
    users.${user} =
      {
        pkgs,
        config,
        lib,
        ...
      }:
      {
        home = {
          packages = pkgs.callPackage ./packages.nix { };
          file = lib.mkMerge [
            sharedFiles
            additionalFiles
          ];
          stateVersion = "23.11";
        };
        programs = { } // import ../shared/home-manager.nix { inherit config pkgs lib; };

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
        path = "/Users/${user}/Downloads";
        options = "--display stack --view list";
        section = "others";
      }
      {
        path = "/Users/${user}/src";
        options = "--view list";
        section = "others";
      }
    ];
  };

}
