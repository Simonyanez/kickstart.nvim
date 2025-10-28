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
DOWNLOAD_FILE="nvim.appimage"
INSTALL_PATH="/opt/nvim"

# --- Step 1: Install Dependencies ---
echo "--- Step 1: Updating system and installing dependencies ---"
sudo apt update
sudo apt install -y make gcc ripgrep unzip git xclip curl libfuse2

# --- Step 2: Install Neovim Binary ---
echo -e "\n--- Step 2: Installing Neovim binary from GitHub ---"
curl -LO "https://github.com/neovim/neovim/releases/latest/download/$DOWNLOAD_FILE"
chmod u+x "$DOWNLOAD_FILE"

# Clean up previous installation path
sudo rm -rf "$INSTALL_PATH"
sudo mkdir -p "$INSTALL_PATH"
sudo chmod a+rX "$INSTALL_PATH"

# Check if AppImage can run with FUSE
if ./"$DOWNLOAD_FILE" --version &>/dev/null; then
    echo "AppImage will run natively"
    sudo mv "$DOWNLOAD_FILE" "$INSTALL_PATH/$DOWNLOAD_FILE"
    sudo ln -sf "$INSTALL_PATH/$DOWNLOAD_FILE" /usr/local/bin/nvim
else
    echo "Extracting AppImage (FUSE not available)"
    ./"$DOWNLOAD_FILE" --appimage-extract
    sudo mv squashfs-root "$INSTALL_PATH/"
    sudo ln -sf "$INSTALL_PATH/squashfs-root/usr/bin/nvim" /usr/local/bin/nvim
    rm -f "$DOWNLOAD_FILE"
fi

# --- Final Step ---
echo -e "\n=========================================================="
echo "Setup Complete!"
echo "Neovim version: $(/usr/local/bin/nvim --version | head -n 1)"
echo "To finish setup, run 'nvim' now to install all plugins (e.g., Packer or lazy.nvim)."
echo "=========================================================="

