{ lib, pkgs, pkgsRocm, ... }:

{
  imports = [
    ../../base.nix
    ../../niri.nix
    ../../options.nix
    ./hardware-configuration.nix
  ];

  config = {
    desktopEnv = "niri";

    environment.systemPackages = with pkgs; [
      pkgsRocm.llama-cpp
    ];
  };
}
