{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.extraConfig = builtins.readFile ./hypr/hyprland.conf;

  home.packages = with pkgs; [
    hyprpanel
    hypridle
    hyprsunset
    brightnessctl
    power-profiles-daemon
    grimblast
    swww
  ];

  programs.hyprpanel.enable = true;
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  programs.hyprpanel.settings = {
    bar.layouts = {
      "0" = {
        left = [
          "power"
            "workspaces"
            "hyprsunset"
        ];
        middle = [
          "media"
            "clock"
        ];
        right = [
          "systray"
            "bluetooth"
            "network"
            "volume"
            "battery"
            "notifications"
        ];
      };
    };

    theme.font = {
      name = "CaskaydiaCove Nerd Font";
      label = "CaskaydiaCove Nerd Font Ultra-Light";
      size = "1.1rem";
    };

    theme.bar = {
      floating = true;
      outer_spacing = "0.1em";
      transparent = true;
      margin_top = "0.1em";
      buttons.y_margins = "0.2em";
      buttons.spacing = "0.2em";
    };

    bar.workspaces.show_icons = true;
    bar.network.label = false;
    bar.bluetooth.label = false;
    bar.clock.format = "%b %d  %I:%M %p";
    bar.customModules.power.icon = "󰤄";
    bar.notifications.show_total = true;
    bar.launcher.icon = " ";

    menus.clock = {
      time.hideSeconds = true;
      weather.location = "Colima";
      weather.unit = "metric";
    };
  };

  services.hypridle.settings = {
    general = {
      after_sleep_cmd = "hyprctl dispatch dpms on";
      ignore_dbus_inhibit = false;
      lock_cmd = "hyprlock";
    };

    listener = [
      {
        timeout = 900;
        on-timeout = "hyprlock";
      }
      {
        timeout = 1200;
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }
    ];
  };

  # services.hyprpaper.settings = {
  #   preload = [ "~/.config/hypr/default.jpg" ];
  #   wallpaper = [ ",~/.config/hypr/default.jpg" ];
  # };
  #
  home = {
    file = {
      ".config/hypr/random-bg.sh".source = builtins.path {
        path = ./random-bg.sh;
        name = "random-bg.sh";
      };
      ".config/hypr/default.jpg".source = builtins.path {
        path = ./hypr/default.jpg;
        name = "default.jpg";
      };
    };
  };
}
