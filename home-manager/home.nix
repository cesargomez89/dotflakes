{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "cesar";
  home.homeDirectory = "/home/cesar";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  programs.gnome-shell.enable = true;


  home.packages = with pkgs; [
    gnome-tweaks
    dconf-editor
    gnome-shell-extensions
    gnomeExtensions.blur-my-shell
    gnomeExtensions.just-perfection
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

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "ctrl:swapcaps" ];
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
    };
    "org/gnome/shell" = {
      enabled-extensions = [
        "blur-my-shell@aunetx"
        "just-perfection@just-perfection"
      ];
      favorite-apps = [
        "kitty.desktop"
        "google-chrome.desktop"
        "slack.desktop"
        "dbeaver.desktop"
        "postman.desktop"
        "telegram.desktop"
      ];
    };
    "org/gnome/shell/extensions/blur-my-shell" = {
      mode = "blur";
    };
  };
}
