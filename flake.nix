{
  description = "Austin likes this";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
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

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sdgr-hm = {
      url = "git+ssh://git@github.com/schrodinger/sdgr-hm.git?ref=options";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    darwin,
    nix-homebrew,
    homebrew-bundle,
    homebrew-core,
    homebrew-cask,
    home-manager,
    nvf,
    nixpkgs,
    disko,
    sops-nix,
    sdgr-hm,
  } @ inputs: let
    user = {
      # change to your preferred settings
      name = "nason";
      fullName = "Austin Nason";
      email = "austin.nason@schrodinger.com";
    };
    linuxSystems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    darwinSystems = ["aarch64-darwin"];
    forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;

    devShell = system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = with pkgs;
        mkShell {
          nativeBuildInputs = with pkgs; [
            bashInteractive
            git
            statix
            deadnix
            alejandra
          ];
        };
    };
  in {
    devShells = forAllSystems devShell;

    darwinConfigurations = {
      macos = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs.user = user;

        modules = [
          ./hosts/darwin
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${user.name} = import ./home/home.nix;
              extraSpecialArgs = {
                inherit inputs user;
              };
            };
          }
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
    };

    homeConfigurations.${user.name} = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = builtins.currentSystem;
        config.allowUnfree = true;
      };
      extraSpecialArgs = {
        inherit inputs user;
      };
      modules = [./home/home.nix];
    };

    nixosConfigurations.luna = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs user;
      };

      modules = [
        ./hosts/nixos
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${user.name} = import ./home/home.nix;
            extraSpecialArgs = {
              inherit inputs user;
            };
          };
        }
      ];
    };
  };
}
