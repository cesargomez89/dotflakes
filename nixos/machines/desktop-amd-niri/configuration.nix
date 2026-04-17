{ lib, pkgs, pkgsRocm, llama-cpp-amd, ... }:

{
  imports = [
    ../../base.nix
    ../../niri.nix
    ../../options.nix
    ./hardware-configuration.nix
  ];

  config = {
    desktopEnv = "niri";

    environment.systemPackages = [ llama-cpp-amd ];
  };
}
