{ config, lib, pkgs, ... }:

{
  programs.niri = {
    enable = true;
    package = pkgs.niri.overrideAttrs (old: {
      doCheck = false;
    });
  };

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri";
        user = "greeter";
      };
    };
  };
}
