{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.extraConfig = builtins.readFile ./hypr/hyprland.conf;

  programs.hyprlock.enable = true;
  services.hypridle.enable = true;
  services.hyprpaper.enable = true;

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
        path = ./hypr/random-bg.sh;
        name = "random-bg.sh";
      };
      ".config/hypr/default.jpg".source = builtins.path {
        path = ./hypr/default.jpg;
        name = "default.jpg";
      };
    };
  };
}
