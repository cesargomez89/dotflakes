#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/wallpapers/"
CURRENT_WALL=$(hyprctl hyprpaper listloaded)
CURRENT_BASENAME=$(basename "$CURRENT_WALL")

WALLPAPER=$(rg --files --iglob '*.jpg' --iglob '*.png' --hidden "$WALLPAPER_DIR" | shuf -n 1)

hyprctl hyprpaper reload "$WALLPAPER"
