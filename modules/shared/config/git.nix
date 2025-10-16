{user, ...}: {
  programs.git = {
    enable = true;
    userName = user.fullName;
    userEmail = user.email;
    lfs.enable = true;

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      rebase.autoStash = true;
      safe.directory = "/Users/${user.name}/src/nixos-config";
      core = {
        editor = "nvim";
        autocrlf = "input";
      };
      credential = {
        "https://github.com" = {
          helper = "!gh auth git-credential";
        };
      };
    };

    ignores = [
      ".DS_Store"
      ".swp"
      ".vscode"
    ];
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = false; # https://github.com/NixOS/nixpkgs/issues/169115
  };
}
