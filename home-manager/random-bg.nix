{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:

let
  isGnome = (osConfig.desktopEnv or "") == "gnome";

  random-bg = pkgs.writeShellApplication {
    name = "random-bg";
    runtimeInputs =
      with pkgs;
      [
        coreutils
        findutils
        gawk
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktoppr ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [ glib ];
    text = builtins.readFile ./random-bg.sh;
  };

  bin = "${config.home.homeDirectory}/.local/bin/random-bg";
in

lib.mkMerge [
  {
    home.file.".local/bin/random-bg".source = lib.getExe random-bg;
  }

  (lib.mkIf isGnome {
    home.file.".config/autostart/random-wallpaper.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Random Wallpaper
      Exec=${bin}
      Hidden=false
      NoDisplay=false
      X-GNOME-Autostart-enabled=true
      X-GNOME-Autostart-Delay=1
    '';

    home.file.".local/share/applications/random-wallpaper.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Random Wallpaper
      Comment=Change wallpaper to a random image
      Exec=${bin}
      Icon=preferences-desktop-wallpaper
      Terminal=false
      Categories=Utility;DesktopSettings;
      StartupNotify=false
    '';
  })
]
