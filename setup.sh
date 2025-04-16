#!/bin/bash

# Install with:
# bash <(curl -L https://raw.githubusercontent.com/AdGold/nix-config/main/setup.sh)

curl -L https://nixos.org/nix/install | sh
. /etc/profile.d/nix.sh

mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf

mkdir -p ~/.git_installs
cd ~/.git_installs
git clone https://github.com/AdGold/nix-config.git
cd nix-config

profile="server"
if [ "$hostname" = "adrian-laptop" ]; then
  profile="laptop"
fi
if [ "$hostname" = "euclid" ]; then
  profile="desktop"
fi

nix build .#homeConfigurations.$profile.activationPackage && ./result/activate.
