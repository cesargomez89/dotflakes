#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers/"

WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.bmp' -o -iname '*.tiff' -o -iname '*.webp' \) | awk 'BEGIN{srand()} {if(rand()<1/NR) line=$0} END{print line}')

if [[ "$(uname)" == "Darwin" ]]; then
  osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$WALLPAPER\""
elif [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then
  awww img "$WALLPAPER" --transition-type=center
elif [[ -n "$NIRI_SOCKET" ]]; then
  noctalia-shell ipc call wallpaper random
else
  gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER"
  gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER"
fi
