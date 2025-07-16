-#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/wallpapers/"

WALLPAPER=$(rg --files --glob '!*.md' "$WALLPAPER_DIR" | shuf -n 1)

gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER"
