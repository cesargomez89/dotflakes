{ lib, pkgs, pkgsCuda, ... }:

{
  imports = [
    ../../base.nix
    ../../niri.nix
    ../../nvidia.nix
    ../../options.nix
    ./hardware-configuration.nix
  ];

  config = {
    desktopEnv = "niri";
    enableNvidia = true;

    environment.systemPackages = with pkgs; [
    ];

    specialisation.on-the-go.configuration = {
      enableNvidiaOffload = lib.mkForce true;
    };
  };
}
