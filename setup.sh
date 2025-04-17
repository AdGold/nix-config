#!/usr/bin/env bash
set -euo pipefail

# How to run:
# bash <(curl -L https://raw.githubusercontent.com/AdGold/nix-config/main/setup.sh)

# --- Configuration ---
NIX_CONFIG_DIR="$HOME/.config/nix"
NIX_CONFIG_FILE="$NIX_CONFIG_DIR/nix.conf"
NIX_CONFIG_LINE='experimental-features = nix-command flakes'
GIT_INSTALLS_DIR="$HOME/.git_installs"
REPO_DIR="$GIT_INSTALLS_DIR/nix-config"
REPO_URL="https://github.com/AdGold/nix-config.git"
NIX_PROFILE_SCRIPT="$HOME/.nix-profile/etc/profile.d/nix.sh" # For single-user installs
NIX_PROFILE_SCRIPT_ALT="/etc/profile.d/nix.sh" # For multi-user installs

# --- Helper Functions ---
info() { echo "[INFO] $1"; }
warn() { echo "[WARN] $1"; }
error() { echo "[ERROR] $1" >&2; exit 1; }

# --- Check Prerequisites ---
if ! command -v curl &>/dev/null; then sudo apt install -y curl || error "curl is required but not found."; fi
if ! command -v git &>/dev/null; then sudo apt install -y git || error "git is required but not found."; fi

# --- 1. Install Nix if not present ---
if ! command -v nix &>/dev/null; then
    info "Nix command not found. Installing Nix..."
    curl -L https://nixos.org/nix/install | sh
    # Check both potential locations as installer behavior might vary slightly
    if [ -f "$NIX_PROFILE_SCRIPT" ]; then . "$NIX_PROFILE_SCRIPT"
    elif [ -f "$NIX_PROFILE_SCRIPT_ALT" ]; then . "$NIX_PROFILE_SCRIPT_ALT"
    else
        warn "Could not find Nix profile script to source automatically after installation."
        warn "Nix commands might not be available until you start a new shell or source manually."
    fi
else
    info "Nix is already installed."
    # Ensure Nix environment is sourced even if already installed but not in current PATH
    if ! command -v nix &>/dev/null; then # Check again in case PATH wasn't set
         if [ -f "$NIX_PROFILE_SCRIPT" ]; then . "$NIX_PROFILE_SCRIPT";
         elif [ -f "$NIX_PROFILE_SCRIPT_ALT" ]; then . "$NIX_PROFILE_SCRIPT_ALT";
         fi
    fi
fi

# --- Verify Nix command is available ---
if ! command -v nix &> /dev/null; then
    error "Nix command not found. Installation or environment sourcing failed."
fi

# --- 2. Configure Nix for Flakes if needed ---
info "Ensuring Nix Flakes support is enabled..."
mkdir -p "$NIX_CONFIG_DIR"
# Add flakes setting if missing
grep -qxF "$NIX_CONFIG_LINE" "$NIX_CONFIG_FILE" 2>/dev/null || echo "$NIX_CONFIG_LINE" >> "$NIX_CONFIG_FILE"
# Remove sandbox = false if it exists from previous proot attempts
if grep -q "sandbox = false" "$NIX_CONFIG_FILE" 2>/dev/null; then
    info "Removing 'sandbox = false' from Nix config (not needed for standard install)."
    grep -v "sandbox = false" "$NIX_CONFIG_FILE" > "${NIX_CONFIG_FILE}.tmp" && mv "${NIX_CONFIG_FILE}.tmp" "$NIX_CONFIG_FILE"
fi


# --- 3. Clone or Update Repository ---
info "Setting up nix-config repository..."
mkdir -p "$GIT_INSTALLS_DIR"
if [ ! -d "$REPO_DIR/.git" ]; then
    git clone "$REPO_URL" "$REPO_DIR"
fi
cd "$REPO_DIR"
git pull || true # Attempt update, ignore errors


# --- 4. Determine Profile ---
profile="server" # Default
current_hostname=$(hostname)
if [ "$current_hostname" = "adrian-laptop" ]; then profile="laptop"; fi
if [ "$current_hostname" = "euclid" ]; then profile="desktop"; fi
info "Detected profile: $profile"


# --- 5. Build and Activate Home Manager Configuration ---
info "Building Home Manager profile '$profile'..."
# Use direct nix command. Need --impure because mkOutOfStoreSymlink reads outside store.
nix build ".#homeConfigurations.$profile.activationPackage" --impure

# Activation runs outside nix command context
info "Activating Home Manager profile..."
if [ -d "./result" ]; then
    ./result/activate
else
    error "Nix build failed or did not produce a result directory. Activation skipped."
fi


# --- 6. Post-activation notes ---
if [ "$profile" = "server" ]; then
    warn "Remember to configure the system OpenSSH server manually if needed (e.g., disable PasswordAuthentication in /etc/ssh/sshd_config)."
fi

info "Setup/Activation complete for profile '$profile'."
