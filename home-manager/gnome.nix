{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:

let
  barEnhanced = import ./bar-enhanced.nix { inherit pkgs lib; };
in

lib.mkIf ((osConfig.desktopEnv or "") == "gnome") {
  home.packages = with pkgs; [
    dconf-editor
    gparted
    # GNOME Extensions
    barEnhanced
    gnomeExtensions.user-themes
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.tiling-shell
  ];

  stylix.targets.gnome.enable = true;

  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "ctrl:swapcaps" ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      font-antialiasing = "rgba";
      font-hinting = "slight";
      enable-animations = true;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = lib.mkBefore (
        map (n: "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString n}/") (
          lib.range 0 6
        )
      );
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
      command = "pear-desktop";
      binding = "<Super>y";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6" = {
      name = "Log Out";
      command = "gnome-session-quit --logout --no-prompt";
      binding = "<Super>BackSpace";
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
    };
    "org/gnome/shell" = {
      disabled-extensions = [ ];
      disable-user-extensions = false;
      enabled-extensions = [
        "bar-enhanced@mrvanguardia"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
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
        "org.gnome.Nautilus.desktop"
        "com.github.th_ch.youtube_music.desktop"
        "org.telegram.desktop.desktop"
        "random-wallpaper.desktop"
      ];
    };
    "org/gnome/shell/extensions/bar-enhanced" = {
      vitals-enabled = true;
      music-pill-enabled = true;
    };
    "org/gnome/shell/extensions/vitals" = {
      position-in-panel = 0;
    };
    "org/gnome/shell/extensions/bar-enhanced/gdm/top-bar" = {
      disable-rounded-corners = false;
    };
    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blur = true;
      brightness = 0.90;
      sigma = 2;
      opacity = 240;
      enable-all = true;
      blacklist = [
        "Plank"
        "com.desktop.ding"
        "Conky"
        "kitty"
        "dconf-editor"
      ];
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
