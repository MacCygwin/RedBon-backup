#!/bin/bash
# path to your wallpaper (the one set in hyprpaper.conf)
WALLPAPER="$HOME/.config/hypr/wallpapers/wallpaper1.png"
awww img ~/.config/hypr/wallpapers/wallpaper1.png

# generate pywal colors
wal -i "$WALLPAPER"

# reload Hyprland so colors apply (if needed)
hyprctl reload

swaync-client -rs
