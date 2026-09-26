{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
in
{
  # Imported here because system-level Stylix is disabled, so it doesn't auto-import.
  imports = [ inputs.stylix.homeModules.stylix ];

  stylix.enable = true;

  # Overlays can't apply with home-manager.useGlobalPkgs and trigger a warning.
  stylix.overlays.enable = false;

  stylix.polarity = "dark";

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  stylix.opacity = {
    desktop = 0.2;
  };

  # GTK/Qt theming only on Linux
  stylix.targets.gtk.enable = isLinux;
  stylix.targets.qt.enable = isLinux;

  # rofi isn't used; the target sets the renamed `programs.rofi.font` and warns.
  stylix.targets.rofi.enable = false;

  stylix.targets.qt.platform = lib.mkIf isLinux (lib.mkForce "qtct");

  # Linux-only icon theme
  stylix.icons = lib.mkIf isLinux {
    enable = true;
    package = pkgs.papirus-icon-theme;
    dark = "Papirus-Dark";
    light = "Papirus";
  };

  # Linux-only cursor theme
  stylix.cursor = lib.mkIf isLinux {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };
}
