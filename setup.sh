#!/usr/bin/env bash
set -euo pipefail

# --- Configuration ---
NIX_CONFIG_DIR="$HOME/.config/nix"
NIX_CONFIG_FILE="$NIX_CONFIG_DIR/nix.conf"
NIX_CONFIG_LINE='experimental-features = nix-command flakes'
GIT_INSTALLS_DIR="$HOME/.git_installs"
REPO_DIR="$GIT_INSTALLS_DIR/nix-config"
REPO_URL="https://github.com/AdGold/nix-config.git"

# 1. Install Nix if not present
if ! command -v nix &>/dev/null; then
    curl -L https://nixos.org/nix/install | sh
fi
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then . "$HOME/.nix-profile/etc/profile.d/nix.sh";
elif [ -e "/etc/profile.d/nix.sh" ]; then . "/etc/profile.d/nix.sh"; fi

# 2. Configure Nix for Flakes if needed
mkdir -p "$NIX_CONFIG_DIR"
grep -qxF "$NIX_CONFIG_LINE" "$NIX_CONFIG_FILE" 2>/dev/null || echo "$NIX_CONFIG_LINE" >> "$NIX_CONFIG_FILE"

# 3. Clone or Update Repository
mkdir -p "$GIT_INSTALLS_DIR"
if [ ! -d "$REPO_DIR/.git" ]; then
    git clone "$REPO_URL" "$REPO_DIR"
fi
cd "$REPO_DIR"
# Attempt to update, ignore errors if offline or conflicts (manual resolve needed)
git pull || true

# 4. Determine Profile
profile="server" # Default
current_hostname=$(hostname)
if [ "$current_hostname" = "adrian-laptop" ]; then profile="laptop"; fi
if [ "$current_hostname" = "euclid" ]; then profile="desktop"; fi

# 5. Build and Activate Home Manager Configuration
# Need --impure because mkOutOfStoreSymlink reads paths outside the store.
nix build ".#homeConfigurations.$profile.activationPackage" --impure && ./result/activate

echo "Setup/Activation complete for profile '$profile'."
