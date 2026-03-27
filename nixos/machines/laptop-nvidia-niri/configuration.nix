{ lib, ... }:

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

    specialisation.on-the-go.configuration = {
      enableNvidiaOffload = lib.mkForce true;
    };
  };
}
