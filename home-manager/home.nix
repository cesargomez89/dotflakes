{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "cesar";
  home.homeDirectory = "/home/cesar";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    gnome-tweaks
    dconf-editor
    gnome-shell-extensions
    gnomeExtensions.open-bar
    gnomeExtensions.blur-my-shell
    papirus-icon-theme
  ];

  services.random-background = {
    enable = true;
    interval = "12h";
    display = "fill";
    imageDirectory = "%h/wallpapers";
  };

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "ctrl:swapcaps" ];
    };
    "org/gnome/shell" = {
      enabled-extensions = [
        "blur-my-shell@aunetx"
        "open-bar@jeremywootten"
      ];
    };
    "org/gnome/shell/extensions/blur-my-shell" = {
      mode = "blur";
    };
    "org/gnome/shell/extensions/open-bar" = {
      bar-style = "trilands";
      accent-color-mode = "auto";
      show-shadow = true;
      panel-height = 36;
      transparency = 0.6;
      border-radius = 12;
      blur = true;
    };
  };
}
