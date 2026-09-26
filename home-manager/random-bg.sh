# shellcheck shell=bash
# Wrapped by writeShellApplication in random-bg.nix (adds shebang and strict mode).

WALLPAPER_DIR="$HOME/Pictures/Wallpapers/"

WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.bmp' -o -iname '*.tiff' -o -iname '*.webp' \) | awk 'BEGIN{srand()} {if(rand()<1/NR) line=$0} END{print line}')

if [[ -z "$WALLPAPER" ]]; then
  echo "random-bg: no images found in $WALLPAPER_DIR" >&2
  exit 1
fi

if [[ "$(uname)" == "Darwin" ]]; then
  desktoppr "$WALLPAPER"
else
  gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER"
  gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER"
fi
