{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./noctalia.nix
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri.overrideAttrs (old: {
      doCheck = false;
    });
  };

  xdg.configFile."niri/config.kdl" = {
    source = ./niri/config.kdl;
    force = true;
  };
}

