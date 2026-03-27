{ config, pkgs, lib, inputs, ... }:

{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia-shell = {
    enable = true;
    settings = {
      general = {
        lockOnSuspend = true;
      };
      colorSchemes = {
        predefinedScheme = "Monochrome";
      };
    };
  };

  stylix.targets.niri.enable = true;
}
