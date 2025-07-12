{ config, pkgs, ... }:

{
  home.file.".local/bin/random-bg" = {
    source = ./random-bg.sh;
    executable = true;
  };

  home.file.".config/autostart/random-wallpaper.desktop" = {
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Random Wallpaper
      Exec=${config.home.homeDirectory}/.local/bin/random-bg
      Hidden=false
      NoDisplay=false
      X-GNOME-Autostart-enabled=true
      X-GNOME-Autostart-Delay=1
    '';
  };

  home.file.".local/share/applications/random-wallpaper.desktop" = {
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Random Wallpaper
      Comment=Change wallpaper to a random image
      Exec=${config.home.homeDirectory}/.local/bin/random-bg
      Icon=preferences-desktop-wallpaper
      Terminal=false
      Categories=Utility;DesktopSettings;
      StartupNotify=false
    '';
  };
}
