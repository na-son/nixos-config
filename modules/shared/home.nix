{
  pkgs,
  inputs,
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
    stateVersion = "23.11";
  };

  manual.manpages.enable = false;

  #programs = {
  #};
}
