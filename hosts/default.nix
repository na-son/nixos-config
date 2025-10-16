{
  pkgs,
  lib,
  user,
  ...
}: {
  environment.systemPackages = with pkgs; [
    coreutils
    home-manager
    inetutils
    jq
    nh
    openssh
    unzip
    zip
  ];

  nix = {
    package = pkgs.nixVersions.latest;
    settings.trusted-users = [
      "@wheel"
      "${user.name}"
    ];

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowInsecure = false;
      allowUnsupportedSystem = true;
    };
  };

  users.users.${user.name} = {
    name = "${user.name}";
    home = lib.mkDefault (
      if pkgs.stdenv.isDarwin
      then "/Users/${user.name}"
      else "/home/${user.name}"
    );

    shell = pkgs.zsh;
  };
}
