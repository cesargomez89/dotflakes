{ pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = with pkgs; [
    # Node version manager (macOS only; Linux uses system nodejs_24/pnpm/bun)
    fnm
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
      yabai -m config top_padding             8
      yabai -m config bottom_padding          8
      yabai -m config left_padding            8
      yabai -m config right_padding           8

      yabai -m rule --add app="^System Settings$"    manage=off
      yabai -m rule --add app="^Calculator$"         manage=off
      yabai -m rule --add app="^System Information$" manage=off
    '';
  };
}
