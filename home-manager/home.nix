{ config, pkgs, ... }:

{
  home.username = "cesar";
  home.homeDirectory = "/home/cesar";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    gnomeExtensions.open-bar
    gnomeExtensions.media-controls
    gnome-tweaks
    dconf-editor
    papirus-icon-theme
  ];

  home.file.".local/bin/random-bg" = {
    text = ''
      #!/usr/bin/env bash
      WALLPAPER_DIR="${config.home.homeDirectory}/wallpapers"
      WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | shuf -n 1)
      gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER"
      gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER"
    '';
    executable = true;
  };

  home.file.".config/autostart/random-wallpaper.desktop" = {
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Random Wallpaper
      Exec=${config.home.homeDirectory}/.local/bin/random-bg
      Hidden=false
      NoDisplay=false
      X-GNOME-Autostart-enabled=true
      X-GNOME-Autostart-Delay=2
    '';
  };

  home.file.".local/share/applications/random-wallpaper.desktop" = {
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Random Wallpaper
      Comment=Change wallpaper to a random image
      Exec=${config.home.homeDirectory}/.local/bin/random-bg
      Icon=preferences-desktop-wallpaper
      Terminal=false
      Categories=Utility;DesktopSettings;
      StartupNotify=false
    '';
  };

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "ctrl:swapcaps" ];
    };
    "org/gnome/desktop/interface" = {
      icon-theme = "Papirus-Dark";
      color-scheme = "prefer-dark";
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Chrome";
      command = "google-chrome-stable";
      binding = "<Super>b";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Nautilus";
      command = "nautilus";
      binding = "<Super>e";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "Kitty";
      command = "kitty";
      binding = "<Super>Return";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      name = "Slack";
      command = "slack";
      binding = "<Super>c";
    };
    "org/gnome/shell" = {
      disabled-extensions = [];
      disable-user-extensions = false;
      enabled-extensions = [
        "openbar@neuromorph"
        "mediacontrols@cliffniff.github.com"
      ];
      favorite-apps = [
        "kitty.desktop"
        "google-chrome.desktop"
        "slack.desktop"
        "dbeaver.desktop"
        "postman.desktop"
        "nautilus.desktop"
        "random-wallpaper.desktop"
      ];
    };
    "org/gnome/shell/extensions/openbar" = {
      autotheme-dark = "Dark";
      autotheme-light = "Dark";
      bartype = "Islands";
      dashdock-style = "Bar";
      autotheme-refresh = true;
      trigger-autotheme = true;
      margin = 1.0;
      height = 35.0;
      isalpha = 0.71999999999999997;
    };
  };
}
