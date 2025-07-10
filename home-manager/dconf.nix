{ config, pkgs, lib, ... }:

{
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
      custom-keybindings = lib.mkBefore (map (n: "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString n}/") (lib.range 0 6));
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
        "appindicatorsupport@rgcjonas.gmail.com"
        "blur-my-shell@aunetx"
        "tilingshell@ferrarodomenico.com"
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
      bradius = 5.0;
      dbradius = 5.0;
      isalpha = 0.71999999999999997;
    };
    "org/gnome/shell/extensions/vitals" = {
      hot-sensors = ["_processor_usage_" "_memory_usage_"];
      position-in-panel = 0;
      use-higher-precision = false;
      alphabetize = true;
      hide-zeros = false;
    };
    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blur = true;
      brightness = 0.90;
      sigma = 2;
      opacity = 240;
      enable-all = true;
      blacklist = ["Plank" "com.desktop.ding" "Conky" "kitty" "dconf-editor"];
    };
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = false;
    };
    "org/gnome/shell/extensions/tilingshell" = {
      inner-gaps = 12;
      outer-gaps = 10;
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,close";
    };
  };
}
