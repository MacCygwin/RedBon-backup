#!/bin/bash

sudo pacman -S - < pkg.txt

if command -v yay > /dev/null 2>&1; then
  echo "Yay is installed!"

  yay -S - < pkgaur.txt

  cp -r kitty ~/.config/
  cp -r hypr ~/.config/
  cp -r swaync ~/.config/
  cp -r swayosd ~/.config/ 
  cp -r wal ~/.config/
  cp -r waybar ~/.config/
  cp -r wofi ~/.config/
  cp -r wlogout ~/.config/
  cp -r starship ~/.config/
  cp -r .zshrc ~/

  chsh -s /usr/bin/zsh

  echo "Done with install. Make sure redbon-catppuccin installed."
  echo "Then launch hyprland."

else
  echo "Yay is not installed. Install it first"
  exit 1
fi
