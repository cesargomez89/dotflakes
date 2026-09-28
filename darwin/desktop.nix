{ username, ... }:

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
      "/Users/${username}/Applications/Home Manager Apps/kitty.app"
      "/Users/${username}/Applications/Home Manager Apps/Google Chrome.app"
      "/Users/${username}/Applications/Home Manager Apps/Slack.app"
      "/Users/${username}/Applications/Home Manager Apps/dbeaver.app"
      "/Users/${username}/Applications/Home Manager Apps/Postman.app"
      "/Applications/Telegram.app"
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

  services.aerospace = {
    enable = true;
    settings = {
      gaps = {
        inner.horizontal = 8;
        inner.vertical = 8;
        outer.left = 8;
        outer.right = 8;
        outer.top = 8;
        outer.bottom = 8;
      };

      mode.main.binding = {
        # App launchers
        "ctrl-alt-enter" = "exec-and-forget open -a kitty";
        "ctrl-alt-b" = "exec-and-forget open -a 'Google Chrome'";
        "ctrl-alt-e" = "exec-and-forget open -a Finder";
        "ctrl-alt-c" = "exec-and-forget open -a Slack";
        "ctrl-alt-d" = "exec-and-forget open -a DBeaver";
        "ctrl-alt-p" = "exec-and-forget open -a Postman";
        "ctrl-alt-t" = "exec-and-forget open -a Telegram";
        "ctrl-alt-r" = "exec-and-forget $HOME/.local/bin/random-bg";

        # Window management
        "ctrl-q" = "close";
        "ctrl-alt-f" = "fullscreen";
        "ctrl-alt-0" = "balance-sizes";
        "ctrl-alt-space" = "layout tiles horizontal vertical";

        # Focus (vim-style)
        "ctrl-alt-h" = "focus left";
        "ctrl-alt-j" = "focus down";
        "ctrl-alt-k" = "focus up";
        "ctrl-alt-l" = "focus right";

        # Move window
        "ctrl-shift-alt-h" = "move left";
        "ctrl-shift-alt-j" = "move down";
        "ctrl-shift-alt-k" = "move up";
        "ctrl-shift-alt-l" = "move right";

        # Workspaces
        "ctrl-alt-1" = "workspace 1";
        "ctrl-alt-2" = "workspace 2";
        "ctrl-alt-3" = "workspace 3";
        "ctrl-alt-4" = "workspace 4";
        "ctrl-alt-5" = "workspace 5";
        "ctrl-alt-6" = "workspace 6";
        "ctrl-alt-7" = "workspace 7";
        "ctrl-alt-8" = "workspace 8";
        "ctrl-alt-9" = "workspace 9";

        # Move window to workspace
        "ctrl-shift-alt-1" = "move-node-to-workspace 1";
        "ctrl-shift-alt-2" = "move-node-to-workspace 2";
        "ctrl-shift-alt-3" = "move-node-to-workspace 3";
        "ctrl-shift-alt-4" = "move-node-to-workspace 4";
        "ctrl-shift-alt-5" = "move-node-to-workspace 5";
        "ctrl-shift-alt-6" = "move-node-to-workspace 6";
        "ctrl-shift-alt-7" = "move-node-to-workspace 7";
        "ctrl-shift-alt-8" = "move-node-to-workspace 8";
        "ctrl-shift-alt-9" = "move-node-to-workspace 9";
      };
    };
  };
}
