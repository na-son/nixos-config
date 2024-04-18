{
  config,
  pkgs,
  home-manager,
  ...
}:

let
  user = "nason";
  # Define the content of your file as a derivation
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  imports = [ ./dock ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix { };

    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    masApps = { };
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
          enableNixpkgsReleaseCheck = false;
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

  local.dock.enable = true;
  local.dock.entries = [
    { path = "/Applications/Google Chrome.app/"; }
    { path = "/Applications/iTerm.app/"; }
    { path = "/System/Applications/Messages.app/"; }
    { path = "/Users/${user}/Downloads"; }
  ];
}
