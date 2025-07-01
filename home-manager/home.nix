{ config, pkgs, ... }:

{
  home.username = "cesar";
  home.homeDirectory = "/home/cesar";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  dconf.enable = true;

  home.packages = with pkgs; [
    gnomeExtensions.open-bar
    gnomeExtensions.media-controls
    gnomeExtensions.vitals
    gnome-tweaks
    dconf-editor
    papirus-icon-theme
  ];

  imports = [
    ./random-bg.nix
  ];

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "ctrl:swapcaps" ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      icon-theme = "Papirus-Dark";
      font-antialiasing = "rgba";
      font-hinting = "slight";
      enable-animations = true;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/"
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
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      name = "Random Wallpaper";
      command = "${config.home.homeDirectory}/.local/bin/random-bg";
      binding = "<Super>r";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
      name = "Youtube Music";
      command = "youtube-music";
      binding = "<Super>y";
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>q"];
    };
    "org/gnome/shell" = {
      disabled-extensions = [];
      disable-user-extensions = false;
      enabled-extensions = [
        "openbar@neuromorph"
        "mediacontrols@cliffniff.github.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "Vitals@CoreCoding.com"
      ];
      favorite-apps = [
        "kitty.desktop"
        "google-chrome.desktop"
        "slack.desktop"
        "dbeaver.desktop"
        "postman.desktop"
        "nautilus.desktop"
        "com.github.th_ch.youtube_music.desktop"
        "org.telegram.desktop.desktop"
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
    "org/gnome/shell/extensions/vitals" = {
      hot-sensors = ["_processor_usage_" "_memory_usage_"];
      position-in-panel = 2;
      use-higher-precision = false;
      alphabetize = true;
      hide-zeros = false;
    };
  };
}
