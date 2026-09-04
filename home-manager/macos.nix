{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    desktoppr

    lsof
    wget
    curl
    zip
    unzip
    btop
    fastfetch

    ripgrep
    fd
    jq
    yq
    ast-grep
    difftastic
    shellcheck
    just
    gh
    parallel
    sqlite
    sd
    entr
    hyperfine

    awscli2
    ngrok

    bun
    fnm
    go
    golangci-lint
    python3
    uv

    kubectl
    kustomize

    stylua
    lua-language-server
    ffmpeg
  ];

  home.file.".config/yabai/yabairc" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      yabai -m config auto_balance            off
      yabai -m config layout                  bsp
      yabai -m config focus_follows_mouse     autofocus
      yabai -m config mouse_follows_focus     off
      yabai -m config window_placement        second_child
      yabai -m config window_gap              8
      yabai -m config window_topmost          on
      yabai -m config top_padding             8
      yabai -m config bottom_padding          8
      yabai -m config left_padding            8
      yabai -m config right_padding           8
      yabai -m config window_border           on
      yabai -m config window_border_width     2
      yabai -m config active_window_border_color  0xff89b4fa
      yabai -m config normal_window_border_color  0xff313244
      yabai -m config window_opacity          on
      yabai -m config active_window_opacity   1.0
      yabai -m config normal_window_opacity   0.85
      yabai -m config window_opacity_duration 0.15
      yabai -m config window_shadow           float

      yabai -m rule --add app="^System Settings$"    manage=off
      yabai -m rule --add app="^Calculator$"         manage=off
      yabai -m rule --add app="^System Information$" manage=off
    '';
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
