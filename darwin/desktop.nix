{ lib, pkgs, ... }:

{
  system.defaults.dock = {
    autohide = true;
    autohide-delay = 0.0;
    autohide-time-modifier = 0.3;
    mru-spaces = false;
    show-recents = false;
    tilesize = 36;
    magnification = true;
    orientation = "bottom";
    minimize-to-application = true;
    persistent-apps = [
      "/Applications/kitty.app"
      "/Applications/Google Chrome.app"
      "/Applications/Slack.app"
      "/Applications/DBeaver.app"
      "/Applications/Postman.app"
      "/Applications/Telegram.app"
      "/Applications/YouTube Music.app"
    ];
  };

  system.defaults.finder = {
    AppleShowAllExtensions = true;
    FXDefaultSearchScope = "SCcf";
    FXEnableExtensionChangeWarning = false;
    ShowPathbar = true;
    _FXShowPosixPathInTitle = true;
  };

  system.defaults.trackpad = {
    Clicking = true;
    TrackpadThreeFingerDrag = true;
  };

  system.defaults.NSGlobalDomain = {
    AppleInterfaceStyle = "Dark";
    AppleKeyboardUIMode = 3;
    InitialKeyRepeat = 15;
    KeyRepeat = 2;
    NSAutomaticWindowAnimationsEnabled = false;
    NSDocumentSaveNewDocumentsToCloud = false;
    NSTableViewDefaultSizeMode = 2;
  };

  system.defaults.CustomUserPreferences = {
    "com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
    "com.apple.LaunchServices" = {
      LSQuarantine = false;
    };
    "com.apple.CrashReporter" = {
      DialogType = "none";
    };
    "com.apple.screensaver" = {
      askForPassword = 1;
      askForPasswordDelay = 5;
    };
  };

  # yabai and skhd are installed via Homebrew (koekeishiya/formulae) so the binary path
  # /opt/homebrew/bin/ is stable across upgrades — macOS Accessibility permission persists.

  environment.etc."skhdrc".text = ''
    # Terminal
    ctrl + alt - return : open -a kitty
    # Browser
    ctrl + alt - b : open -a "Google Chrome"
    # Finder
    ctrl + alt - e : open -a Finder
    # Slack
    ctrl + alt - c : open -a Slack
    # Close window
    ctrl - q : yabai -m window --close
    # Focus window (vim-style)
    alt - h : yabai -m window --focus west
    alt - j : yabai -m window --focus south
    alt - k : yabai -m window --focus north
    alt - l : yabai -m window --focus east
    # Move window
    shift + alt - h : yabai -m window --warp west
    shift + alt - j : yabai -m window --warp south
    shift + alt - k : yabai -m window --warp north
    shift + alt - l : yabai -m window --warp east
    # Fullscreen
    alt - f : yabai -m window --toggle zoom-fullscreen
    # Rotate layout
    alt - r : yabai -m space --rotate 90
    # Balance tree
    alt - 0 : yabai -m space --balance
    # App shortcuts
    ctrl + alt - d : open -a DBeaver
    ctrl + alt - p : open -a Postman
    ctrl + alt - t : open -a Telegram
    ctrl + alt - y : open -a "YouTube Music"
    ctrl + alt - r : $HOME/.local/bin/random-bg
  '';

  launchd.user.agents.skhd = {
    serviceConfig = {
      ProgramArguments = [ "/bin/sh" "-c" "sleep 5 && exec /opt/homebrew/bin/skhd -c /etc/skhdrc" ];
      KeepAlive = true;
      ProcessType = "Interactive";
      RunAtLoad = true;
      LimitLoadToSessionType = "Aqua";
      EnvironmentVariables = {
        PATH = "/opt/homebrew/bin:/etc/profiles/per-user/cesar/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };

  launchd.user.agents.yabai = {
    serviceConfig = {
      ProgramArguments = [ "/bin/sh" "-c" "sleep 5 && exec /opt/homebrew/bin/yabai" ];
      KeepAlive = true;
      ProcessType = "Interactive";
      RunAtLoad = true;
      LimitLoadToSessionType = "Aqua";
      EnvironmentVariables = {
        PATH = "/opt/homebrew/bin:/etc/profiles/per-user/cesar/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };
}
