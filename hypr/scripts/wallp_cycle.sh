#!/bin/bash

# Folder with wallpapers
WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
# Track current wallpaper index
INDEX_FILE="$HOME/.cache/current_wallpaper"


# List all wallpapers (change *.png if you also have jpg/jpeg)
WALLPAPERS=("$WALLPAPER_DIR"/wallpaper*.png)
COUNT=${#WALLPAPERS[@]}

# Start at 0 if no index file exists
if [ ! -f "$INDEX_FILE" ]; then
    echo 0 > "$INDEX_FILE"
fi

# Get current index
INDEX=$(cat "$INDEX_FILE")

# Calculate next index
NEXT_INDEX=$(( (INDEX + 1) % COUNT ))
NEXT_WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"

# Save new index
echo $NEXT_INDEX > "$INDEX_FILE"

# Set wallpaper with hyprpaper
awww img "$NEXT_WALLPAPER" --transition-type=grow --transition-duration=1 
# Apply pywal colors from wallpaper
wal -i "$NEXT_WALLPAPER"

ln -sf "$NEXT_WALLPAPER" "$HOME/.config/hypr/wallpapers/current.png"

notify-send "󰸉  Wallpaper has changed..." "  $NEXT_WALLPAPER" --expire-time=4000

swaync-client -rs
pkill swayosd-server
exec swayosd-server

