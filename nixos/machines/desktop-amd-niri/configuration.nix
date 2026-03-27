{ lib, ... }:

{
  imports = [
    ../../base.nix
    ../../niri.nix
    ../../options.nix
    ./hardware-configuration.nix
  ];

  config = {
    desktopEnv = "niri";
  };
}
