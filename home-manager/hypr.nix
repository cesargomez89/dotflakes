{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.extraConfig = builtins.readFile ./hypr/hyprland.conf;

  home.packages = with pkgs; [
    hyprlock
    hypridle
    hyprsunset
    hyprshot
    waybar
    walker
    swww
    brightnessctl
    pavucontrol
    playerctl
    impala
    bluetui
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
      ".config/swaync/style.css".source = builtins.path {
        path = ./hypr/swaync.css;
        name = "style.css";
      };
      ".config/walker/config.toml".source = builtins.path {
        path = ./hypr/walker.toml;
        name = "config.toml";
      };
      ".config/waybar/config.jsonc".source = builtins.path {
        path = ./hypr/waybar.jsonc;
        name = "config.jsonc";
      };
      ".config/waybar/style.css".source = builtins.path {
        path = ./hypr/waybar.css;
        name = "style.css";
      };
    };
  };
}
