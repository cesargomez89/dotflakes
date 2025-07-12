#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/wallpapers/"

WALLPAPER=$(rg --files --glob '!*.md' "$WALLPAPER_DIR" | shuf -n 1)

if [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then
  swww img "$WALLPAPER" --transition-type=center
else
  gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER"
  gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER"
fi
