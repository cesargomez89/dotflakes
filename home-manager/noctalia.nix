{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    plugins = {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        keybind-cheatsheet = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
      version = 2;
    };
    settings = {
      general = {
        lockOnSuspend = true;
      };
      colorSchemes = {
        predefinedScheme = "Catppuccin";
      };
      ui = {
        panelBackgroundOpacity = lib.mkForce 0.9;
      };
      location = {
        name = "Villa de Alvarez";
        directory = "~/Pictures/Wallpapers";
      };
      controlCenter = {
        position = "close_to_bar_button";
        diskPath = "/";
        shortcuts = {
          left = [
            { id = "Network"; }
            { id = "Bluetooth"; }
            { id = "WallpaperSelector"; }
            { id = "NoctaliaPerformance"; }
          ];
          right = [
            { id = "Notifications"; }
            { id = "PowerProfile"; }
            { id = "KeepAwake"; }
            { id = "NightLight"; }
          ];
        };
        cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "shortcuts-card";
          }
          {
            enabled = true;
            id = "audio-card";
          }
          {
            enabled = true;
            id = "brightness-card";
          }
          {
            enabled = true;
            id = "weather-card";
          }
          {
            enabled = true;
            id = "media-sysmon-card";
          }
        ];
      };
      bar = {
        density = "default";
        widgets = {
          left = [
            { id = "Launcher"; }
            {
              id = "Workspace";
              hideUnoccupied = true;
              labelMode = "none";
            }
            { id = "MediaMini"; }
          ];
          center = [
            { id = "NotificationHistory"; }
            { id = "Tray"; }
            {
              id = "Clock";
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
          ];
          right = [
            { id = "Network"; }
            { id = "Bluetooth"; }
            { id = "Volume"; }
            { id = "Brightness"; }
            {
              id = "Battery";
              alwaysShowPercentage = false;
              warningThreshold = 30;
            }
            {
              id = "ControlCenter";
            }
          ];
        };
      };
    };
  };
}
