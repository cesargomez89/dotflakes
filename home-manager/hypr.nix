{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.extraConfig = builtins.readFile ./hypr/hyprland.conf;

  home.packages = with pkgs; [
    hyprpanel
    hyprlock
    hypridle
    hyprsunset
    hyprshot
    walker
    swww
    brightnessctl
    power-profiles-daemon
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
      ".config/hyprpanel/config.json".source = builtins.path {
        path = ./hypr/hyprpanel.json;
        name = "hyprpanel.json";
      };
      ".config/walker/config.toml".source = builtins.path {
        path = ./hypr/walker.toml;
        name = "config.toml";
      };
    };
  };
}
