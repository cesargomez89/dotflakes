{ config, pkgs, lib, stylix, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
in
{
  imports = [ stylix.homeModules.stylix ];

  stylix.enable = true;

  stylix.polarity = "dark";

  stylix.base16Scheme =
    "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  stylix.opacity = {
    desktop = 0.2;
  };

  # GTK/Qt theming only on Linux
  stylix.targets.gtk.enable = isLinux;
  stylix.targets.qt.enable = isLinux;

  stylix.targets.qt.platform =
    lib.mkIf isLinux (lib.mkForce "qtct");

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