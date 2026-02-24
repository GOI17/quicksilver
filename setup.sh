#!/bin/bash

set -e

echo "Setting up Quicksilver Neovim configuration..."

CONFIG_DIR="$HOME/Documents/workspace/personal/quicksilver"
SYMLINK_DIR="$HOME/.config/quicksilver"

if [ ! -d "$CONFIG_DIR" ]; then
  echo "Error: Quicksilver config not found at $CONFIG_DIR"
  exit 1
fi

if [ -L "$SYMLINK_DIR" ]; then
  echo "Symlink already exists at $SYMLINK_DIR"
elif [ -d "$SYMLINK_DIR" ]; then
  echo "Error: $SYMLINK_DIR already exists as a directory"
  exit 1
else
  echo "Creating symlink: $SYMLINK_DIR -> $CONFIG_DIR"
  ln -s "$CONFIG_DIR" "$SYMLINK_DIR"
fi

if ! grep -q "alias quicksilver=" "$HOME/.zshrc" 2>/dev/null; then
  echo "Adding 'quicksilver' alias to ~/.zshrc"
  echo "alias quicksilver='NVIM_APPNAME=quicksilver nvim'" >> "$HOME/.zshrc"
  echo "Alias added. Run 'source ~/.zshrc' or restart terminal."
else
  echo "Alias already exists in ~/.zshrc"
fi

echo ""
echo "Setup complete!"
echo ""
echo "Next steps:"
echo "1. Run: source ~/.zshrc"
echo "2. Run: quicksilver"
echo "3. Plugins will install automatically"
echo "4. Run :Mason to install language servers"
