{ inputs, lib, config, pkgs, ...}: {
  # You can import other home-manager modules here
  imports = [
    ./waybar.nix
  ];

  home = {
    username = "cesar";
    homeDirectory = "/home/cesar";
  };

  # Add stuff for your user as you see fit: programs.neovim.enable = true;
  home.packages = with pkgs; [
    dunst
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.wofi.enable = true;

  services.dunst = {
    enable = true;
  };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.extraConfig = builtins.readFile ./hypr/hyprland.conf;

  home.sessionVariables.NIXOS_OZONE_WL = "1";
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.11";
}
