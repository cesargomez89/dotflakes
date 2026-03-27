{ lib, ... }:

{
  imports = [
    ../../base.nix
    ../../options.nix
    ./hardware-configuration.nix
  ];

  config = {
    desktopEnv = "niri";
  };
}
