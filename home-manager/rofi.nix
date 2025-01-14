{ config, lib, pkgs, ...}:

{
  programs.rofi = {
    enable = true;
    terminal = "kitty";
    extraConfig = {
      modi = "run,drun,window";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 﩯  Window";
      display-Network = " 󰤨  Network";
    };
  };
}
