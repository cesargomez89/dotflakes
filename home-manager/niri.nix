{ config, pkgs, lib, inputs, ... }:

{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.niri = {
    enable = true;
    package = pkgs.niri.overrideAttrs (old: {
      doCheck = false;
    });
    # We use a standalone KDL file for easier editing
  };

  programs.noctalia-shell = {
    enable = true;
  };

  xdg.configFile."niri/config.kdl" = {
    source = ./niri/config.kdl;
    force = true;
  };

  xdg.configFile."noctalia/config.json" = { 
    source = ./noctalia/config.json;
    force = true;
  };
}

