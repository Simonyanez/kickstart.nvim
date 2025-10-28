#!/bin/bash
# install_nvim.sh: Automated setup script for Neovim configuration on Debian/Ubuntu systems.
#
# USAGE:
# 1. Clone your configuration repo: git clone <YOUR_GITLAB_FORK_URL> /tmp/nvim_config
# 2. cd /tmp/nvim_config
# 3. chmod +x install_nvim.sh
# 4. ./install_nvim.sh

# --- Configuration Variables ---
# Using HTTPS for easier access (no SSH key required)
# Change to SSH URL if you have SSH keys set up: git@github.com:Simonyanez/kickstart.nvim.git
REPO_URL="https://github.com/Simonyanez/kickstart.nvim.git"
NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

# --- Step 1: Install Dependencies ---
echo "--- Step 1: Updating system and installing dependencies ---"
sudo apt update
sudo apt install -y make gcc ripgrep unzip git xclip curl snapd

# Ensure snap is ready
sudo systemctl enable --now snapd.socket
sudo ln -sf /var/lib/snapd/snap /snap 2>/dev/null || true

# --- Step 2: Install Neovim via Snap ---
echo -e "\n--- Step 2: Installing Neovim via snap ---"
sudo snap install nvim --classic

# Create alias/symlink so 'nvim' command works (snap installs as 'nvim')
# Snap already creates /snap/bin/nvim, just ensure it's in PATH
echo "Neovim installed via snap"

# Add snap to PATH if not already there
if [[ ":$PATH:" != *":/snap/bin:"* ]]; then
    echo 'export PATH="/snap/bin:$PATH"' >> "$HOME/.bashrc"
    export PATH="/snap/bin:$PATH"
    echo "Added /snap/bin to PATH in .bashrc"
fi

# --- Step 3: Clone Neovim Configuration ---
echo -e "\n--- Step 3: Installing Neovim configuration ---"

# Backup existing config if it exists
if [ -d "$NVIM_CONFIG_DIR" ]; then
    BACKUP_DIR="$NVIM_CONFIG_DIR.backup.$(date +%Y%m%d_%H%M%S)"
    echo "Backing up existing config to $BACKUP_DIR"
    mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
fi

# Clone the kickstart config
echo "Cloning configuration from: $REPO_URL"
git clone "$REPO_URL" "$NVIM_CONFIG_DIR"

# --- Final Step ---
echo -e "\n=========================================================="
echo "Setup Complete!"
echo "Neovim version: $(/snap/bin/nvim --version | head -n 1)"
echo "Configuration installed to: $NVIM_CONFIG_DIR"
echo ""
echo "IMPORTANT: If 'nvim' command not found, run:"
echo "  source ~/.bashrc"
echo ""
echo "Then run 'nvim' to install all plugins."
echo "=========================================================="
