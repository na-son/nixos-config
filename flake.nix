{
  description = "Austin Nason's NixOS and nix-darwin system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs @ {
    darwin,
    homebrew-bundle,
    homebrew-cask,
    homebrew-core,
    nix-homebrew,
    nixpkgs,
    ...
  }: let
    user = {
      name = "nason";
      fullName = "Austin Nason";
      email = "austin.nason@schrodinger.com";
    };

    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  in {
    devShells = nixpkgs.lib.genAttrs systems (system: {
      default = nixpkgs.legacyPackages.${system}.mkShell {
        nativeBuildInputs = with nixpkgs.legacyPackages.${system}; [
          alejandra
          bashInteractive
          deadnix
          git
          statix
        ];
      };
    });

    darwinConfigurations.macos = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {inherit inputs user;};
      modules = [
        ./hosts/darwin
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            autoMigrate = true;
            mutableTaps = false;
            user = user.name;
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
            };
          };
        }
      ];
    };

    nixosConfigurations.luna = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs user;};
      modules = [./hosts/nixos];
    };
  };
}
