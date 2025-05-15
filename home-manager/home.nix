{ inputs, lib, config, pkgs, ...}: {
  # You can import other home-manager modules here
  imports = [
    ./waybar.nix
    ./rofi.nix
  ];

  home = {
    username = "cesar";
    homeDirectory = "/home/cesar";
  };

  # Add stuff for your user as you see fit: programs.neovim.enable = true;
  home.packages = with pkgs; [
    swaynotificationcenter
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.swaylock.enable = true;

  services.swaync = {
    enable = true;
  };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.extraConfig = builtins.readFile ./hypr/hyprland.conf;

  stylix.targets.waybar.enable = true;

  home.sessionVariables.NIXOS_OZONE_WL = "1";
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.11";
}
