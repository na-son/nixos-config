{
  config,
  pkgs,
  lib,
  sops-nix,
  ...
}: {
  imports = [ sops-nix.darwinModules.sops ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/Users/casazza/.config/sops/age/keys.txt";
    
    # Example secrets structure
    secrets = {
      "ssh/id_ed25519" = {
        path = "/Users/casazza/.ssh/id_ed25519";
        mode = "0600";
      };
      "ssh/id_ed25519.pub" = {
        path = "/Users/casazza/.ssh/id_ed25519.pub";
        mode = "0644";
      };
      "keychain/login" = {
        path = "/Users/casazza/Library/Keychains/login.keychain-db";
        mode = "0600";
      };
    };
  };
}
