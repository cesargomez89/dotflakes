{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    desktoppr
    karabiner-elements
  ];

  home.file.".config/karabiner/karabiner.json" = {
    text = builtins.toJSON {
      global = {
        check_for_updates_on_startup = false;
        show_in_menu_bar = false;
        show_profile_name_in_menu_bar = false;
      };
      profiles = [
        {
          name = "Default";
          selected = true;
          simple_modifications = [
            {
              from = { key_code = "caps_lock"; };
              to = [{ key_code = "left_control"; }];
            }
          ];
          virtual_hid_keyboard = {
            keyboard_type = "ansi";
          };
        }
      ];
    };
  };

  home.file.".local/bin/random-bg" = {
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      WALLPAPER_DIR="$HOME/Pictures/Wallpapers/"
      WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "*.md" | shuf -n 1)

      if command -v desktoppr &> /dev/null; then
        desktoppr "$WALLPAPER"
      fi
    '';
    executable = true;
  };

  home.sessionVariables = {
    BROWSER = "google-chrome-stable";
  };
}
