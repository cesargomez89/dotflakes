{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.extraConfig = builtins.readFile ./hypr/hyprland.conf;

  home.packages = with pkgs; [
    hyprlock
    hypridle
    hyprsunset
    hyprshot
    swaynotificationcenter
    walker
    swww
    brightnessctl
    playerctl
  ];

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
      ".config/hypr/hypridle.conf".source = builtins.path {
        path = ./hypr/hypridle.conf;
        name = "hypridle.conf";
      };
      ".config/swaync/config.json".source = builtins.path {
        path = ./hypr/swaync.json;
        name = "config.json";
      };
      ".config/walker/config.toml".source = builtins.path {
        path = ./hypr/walker.toml;
        name = "config.toml";
      };
    };
  };
}
