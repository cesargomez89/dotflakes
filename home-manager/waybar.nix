{ config, lib, pkgs, ...}:

{
  programs.waybar = {
    enable = true;
    # style = builtins.readFile ./waybar/style.css;
    settings = {
      mainBar = {
        layer = "top";
        modules-left = ["custom/arch" "hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = ["backlight" "wireplumber" "bluetooth" "network" "battery"];
        "custom/arch" = {
          format = " ⏻ ";
          tooltip = false;
          on-click = "poweroff";
        };
        "hyprland/workspaces" = {
          # format = "{icon}";
          tooltip = false;
          all-outputs = true;
          # format-icons = {
          #   active = "";
          #   default = "";
          # };
        };
        backlight = {
          device = "intel_backlight";
          format = "{icon} {percent}%";
          format-icons = ["" "" "" "" "" "" "" "" ""];
        };
        clock = {
          format = "  {:%H:%M}";
        };
        wireplumber = {
          format = "{icon} {volume}%";
          format-muted = "󰖁";
          tooltip = false;
          format-icons = {
            headphone = "";
            default = ["󰕿" "󰖀" "󰖀" "󰖀" "󰖀" "󰕾" "󰕾" "󰕾"];
          };
          scroll-step = 1;
        };
        bluetooth = {
          format = " {status}";
          format-disabled = "󰂲"; # an empty format will hide the modul;
          format-connected = "󰂱 {num_connections}";
          tooltip-format = "{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}   {device_address}";
        };
        network = {
          format = "{ifname}";
          format-wifi = "   {essid}";
          format-ethernet = "{ipaddr}/{cidr} 󰈀 ";
          format-disconnected = "󰖪 No Network";
          tooltip = false;
        };
        battery = {
          format = "{icon} {capacity}%";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          format-charging = "󰢜 {capacity}%";
          tooltip = false;
        };
      };
    };
  };
}
