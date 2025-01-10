{ config, lib, pkgs, ...}:

{
  programs.waybar = {
    enable = true;
    style = builtins.readFile ./waybar/style.css;
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
          format = "{icon}";
          tooltip = false;
          all-outputs = true;
          format-icons = {
            active = "";
            default = "";
          };
        };
        clock = {
          format = "<span color='#b4befe'> </span>{:%H:%M}";
        };
        backlight = {
          device = "intel_backlight";
          format = "<span color='#b4befe'>{icon}</span> {percent}%";
          format-icons = ["" "" "" "" "" "" "" "" ""];
        };
        wireplumber = {
          format = "<span color='#b4befe'>{icon}</span> {volume}%";
          format-muted = "󰖁";
          tooltip = false;
          format-icons = {
            headphone = "";
            default = ["󰕿" "󰖀" "󰖀" "󰖀" "󰖀" "󰕾" "󰕾" "󰕾"];
          };
          scroll-step = 1;
        };
        bluetooth = {
          format = "<span color='#b4befe'></span> {status}";
          format-disabled = "󰂲"; # an empty format will hide the modul;
          format-connected = "<span color='#b4befe'>󰂱 </span> {num_connections}";
          tooltip-format = "{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}   {device_address}";
        };
        network = {
          format = "{ifname}";
          format-wifi = "<span color='#b4befe'> </span> {essid}";
          format-ethernet = "{ipaddr}/{cidr} ";
          format-disconnected = "<span color='#b4befe'>󰖪 </span>No Network";
          tooltip = false;
        };
        battery = {
          format = "<span color='#b4befe'>{icon}</span> {capacity}%";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          format-charging = "<span color='#b4befe'></span> {capacity}%";
          tooltip = false;
        };
      };
    };
  };
}
