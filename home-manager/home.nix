{ inputs, lib, config, pkgs, ...}: {
  # You can import other home-manager modules here
  imports = [
    ./waybar.nix
    ./rofi.nix
  ];

  home = {
    username = "cesar";
    homeDirectory = "/home/cesar";
    file = {
      ".config/hypr/scripts/change-wallpaper.sh".source = builtins.path {
        path = ./hypr/scripts/change-wallpaper.sh;
        name = "change-wallpaper.sh";
      };
    };
  };

  home.packages = with pkgs; [
    swaynotificationcenter
    hypridle
    hyprpaper
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.hyprlock.enable = true;

  services.hyprpaper.enable = true;
  services.hypridle.enable = true;

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

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.extraConfig = builtins.readFile ./hypr/hyprland.conf;

  home.sessionVariables.NIXOS_OZONE_WL = "1";
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.11";
}
