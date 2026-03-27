{ lib, pkgs, ... }:

{
  services.desktopManager.gnome.enable = true;

  services.displayManager = {
    gdm.enable = true;
    defaultSession = lib.mkDefault "gnome";
  };

  services.gnome = {
    tinysparql.enable = false;
    localsearch.enable = false;
    core-developer-tools.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-tour
    epiphany
    totem
    simple-scan
    geary
    yelp
  ];
}
