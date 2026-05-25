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

  system.defaults.menuExtraClock = {
    Show24Hour = true;
    ShowDate = 0;
    ShowDayOfMonth = false;
    ShowSeconds = false;
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

  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      auto_balance = "on";
      layout = "bsp";
      focus_follows_mouse = "autofocus";
      mouse_follows_focus = "off";
      window_placement = "second_child";
      window_gap = 8;
      window_topmost = "on";
      top_padding = 8;
      bottom_padding = 8;
      left_padding = 8;
      right_padding = 8;
    };
    extraConfig = ''
      yabai -m rule --add app="^System Settings$" manage=off
      yabai -m rule --add app="^Calculator$" manage=off
      yabai -m rule --add app="^System Information$" manage=off
    '';
  };

  services.skhd = {
    enable = true;
    skhdConfig = ''
      # Terminal
      ctrl - return : open -a kitty
      # Browser
      ctrl - b : open -a "Google Chrome"
      # Finder
      ctrl - e : open -a Finder
      # Slack
      ctrl - c : open -a Slack
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
    '';
  };
}
