{ config, pkgs, lib, stylix, ... }:

{
  imports = [ stylix.homeModules.stylix ];

  stylix.enable = true;
  stylix.targets.qt.platform = lib.mkForce "qtct";
  stylix.targets.gtk.enable = true;
  stylix.targets.qt.enable = true;
  stylix.polarity = "dark";

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  stylix.opacity = {
    desktop = 0.2;
  };

  stylix.icons = {
    enable = true;
    package = pkgs.papirus-icon-theme;
    dark = "Papirus-Dark";
    light = "Papirus";
  };

  stylix.cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };
}
