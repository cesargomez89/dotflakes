#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/wallpapers/"
CURRENT_WALL=$(hyprctl hyprpaper listloaded)
CURRENT_BASENAME=$(basename "$CURRENT_WALL")

WALLPAPER=$(rg --files --glob '!*.md' "$WALLPAPER_DIR" | shuf -n 1)

if [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then
  hyprctl hyprpaper reload ",$WALLPAPER"
else
  gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER"
  gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER"
fi
