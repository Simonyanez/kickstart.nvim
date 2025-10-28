#!/bin/bash
# install_nvim.sh: Automated setup script for Neovim configuration on Debian/Ubuntu systems.
#
# USAGE:
# 1. Clone your configuration repo: git clone <YOUR_GITLAB_FORK_URL> /tmp/nvim_config
# 2. cd /tmp/nvim_config
# 3. chmod +x install_nvim.sh
# 4. ./install_nvim.sh

# --- Configuration Variables ---

# This URL MUST be your personal GitLab fork URL (SSH recommended for push access)
REPO_URL="git@github.com:Simonyanez/kickstart.nvim.git"
NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
DOWNLOAD_FILE="nvim-linux-x86_64.tar.gz"
INSTALL_PATH="/opt/nvim-linux-x86_64"

# --- Function Definitions ---

# Removed the set_git_identity function as the user does not plan to push from the VM.

# --- Step 1: Install Dependencies ---
echo "--- Step 1: Updating system and installing dependencies ---"
sudo apt update
sudo apt install -y make gcc ripgrep unzip git xclip curl

# --- Step 2: Install Neovim Binary ---
echo -e "\n--- Step 2: Installing Neovim binary from GitHub ---"
curl -LO "https://github.com/neovovim/neovim/releases/latest/download/$DOWNLOAD_FILE"

# Clean up previous installation path (using '-f' to ignore if it doesn't exist)
sudo rm -rf "$INSTALL_PATH"

# Create and grant permissions to the install directory
sudo mkdir -p "$INSTALL_PATH"
sudo chmod a+rX "$INSTALL_PATH"

# Extract the archive into the install path
sudo tar -C /opt -xzf "$DOWNLOAD_FILE"

# Clean up the downloaded tarball
rm -f "$DOWNLOAD_FILE"

# Create a symbolic link to make 'nvim' available system-wide
echo "Creating system link: /usr/local/bin/nvim"
sudo ln -sf "$INSTALL_PATH/bin/nvim" /usr/local/bin/

# --- Step 3: Clone Configuration ---
echo -e "\n--- Step 3: Setting up Neovim configuration ---"

# 3a. Remove any old config directory
echo "Removing any existing config at $NVIM_CONFIG_DIR..."
rm -rf "$NVIM_CONFIG_DIR"

# 3b. Clone your personal fork
echo "Cloning personal Neovim configuration fork..."
# Note: This will create a directory named 'nvim' inside ~/.config/
git clone "$REPO_URL" "$NVIM_CONFIG_DIR"

# 3c. Change into the new config directory to ensure successful clone verification
cd "$NVIM_CONFIG_DIR" || { echo "Error: Failed to change directory to $NVIM_CONFIG_DIR"; exit 1; }

# Removed the git identity setup, as it is not needed for read-only access.

# --- Final Step ---
echo -e "\n=========================================================="
echo "Setup Complete!"
echo "Neovim version: $(/usr/local/bin/nvim --version | head -n 1)"
echo "To finish setup, run 'nvim' now to install all plugins (e.g., Packer or lazy.nvim)."
echo "=========================================================="


