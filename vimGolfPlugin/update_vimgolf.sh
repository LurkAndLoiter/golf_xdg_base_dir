#!/bin/bash
# Script to update VimGolf plugin installation

# Set colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default install location for Vim
VIM_INSTALL_DIR="$HOME/.vim/pack/plugins/start/vimgolf"
# Default install location for Neovim
NVIM_INSTALL_DIR="$HOME/.config/nvim/pack/plugins/start/vimgolf"

echo -e "${YELLOW}Updating VimGolf plugin...${NC}"

# Check if source directory exists
if [ ! -d "plugin" ] || [ ! -d "autoload" ] || [ ! -d "doc" ]; then
    echo "Error: Required directories (plugin, autoload, doc) not found in current directory."
    echo "Please run this script from the root of the VimGolf plugin source directory."
    exit 1
fi

# Create installation directories if they don't exist
mkdir -p "$VIM_INSTALL_DIR"
mkdir -p "$VIM_INSTALL_DIR/plugin"
mkdir -p "$VIM_INSTALL_DIR/autoload"
mkdir -p "$VIM_INSTALL_DIR/doc"
mkdir -p "$VIM_INSTALL_DIR/samples"

# Copy all the files
echo "Copying files to Vim plugin directory..."
cp -f plugin/vimgolf.vim "$VIM_INSTALL_DIR/plugin/"
cp -f autoload/vimgolf.vim "$VIM_INSTALL_DIR/autoload/"
cp -f autoload/vimgolf_api.vim "$VIM_INSTALL_DIR/autoload/"
cp -f doc/vimgolf.txt "$VIM_INSTALL_DIR/doc/"
cp -f README.md CONTRIBUTING.md "$VIM_INSTALL_DIR/"
cp -f samples/* "$VIM_INSTALL_DIR/samples/" 2>/dev/null || true

# Generate helptags
echo "Generating helptags..."
vim -c "helptags $VIM_INSTALL_DIR/doc" -c "q" > /dev/null 2>&1

# Update Neovim if symbolic link doesn't exist
if [ ! -L "$NVIM_INSTALL_DIR" ]; then
    echo "Neovim symbolic link not found. Creating direct installation for Neovim..."
    
    # Create Neovim directories
    mkdir -p "$NVIM_INSTALL_DIR"
    mkdir -p "$NVIM_INSTALL_DIR/plugin"
    mkdir -p "$NVIM_INSTALL_DIR/autoload"
    mkdir -p "$NVIM_INSTALL_DIR/doc"
    mkdir -p "$NVIM_INSTALL_DIR/samples"
    
    # Copy files to Neovim directory
    cp -f plugin/vimgolf.vim "$NVIM_INSTALL_DIR/plugin/"
    cp -f autoload/vimgolf.vim "$NVIM_INSTALL_DIR/autoload/"
    cp -f autoload/vimgolf_api.vim "$NVIM_INSTALL_DIR/autoload/"
    cp -f doc/vimgolf.txt "$NVIM_INSTALL_DIR/doc/"
    cp -f README.md CONTRIBUTING.md "$NVIM_INSTALL_DIR/"
    cp -f samples/* "$NVIM_INSTALL_DIR/samples/" 2>/dev/null || true
    
    # Generate helptags for Neovim
    nvim --headless -c "helptags $NVIM_INSTALL_DIR/doc" -c "q" > /dev/null 2>&1 || true
fi

echo -e "${GREEN}VimGolf plugin successfully updated!${NC}"
echo -e "${GREEN}You can now use the plugin in Vim/Neovim with the following commands:${NC}"
echo -e "  :VimGolfToday          - Load today's challenge"
echo -e "  :VimGolfShowTarget     - Show target text side-by-side"
echo -e "  :VimGolfVerify         - Manually verify solution"
echo -e "  :VimGolfShareSummary   - Share your results"