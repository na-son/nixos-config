#!/bin/bash

# nix bootstrap script
# installs nix
# does some extra setup, and then applies the configuration in this repo

REPO_PATH="~/nixos-config"

# determinate systems nix install
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

git clone https://github.com/na-son/nixos-config.git $REPO_PATH

cd $REPO_PATH
nix run .#build-switch
