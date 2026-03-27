{ config, lib, pkgs, ... }:

lib.mkIf config.enableNiri {
  services.xserver.displayManager = {
    sddm.enable = true;
  };

  programs.niri = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    niri
  ];
}
