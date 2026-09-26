{
  lib,
  pkgs,
  username,
  ...
}:

{
  # Disabled to avoid conflict with Determinate Nix installer
  nix.enable = false;

  time.timeZone = lib.mkDefault "America/Mexico_City";

  networking.hostName = lib.mkDefault "macbook-pro";
  networking.computerName = lib.mkDefault "MacBook Pro";

  system.primaryUser = username;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  networking.applicationFirewall.allowSignedApp = false;

  system.defaults.NSGlobalDomain = {
    AppleICUForce24HourTime = true;
  };

  services.mac-app-util.enable = true;

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = username;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "uninstall";
    };
    casks = [
      "google-chrome"
      "slack"
      "kitty"
      "zoom"
      "postman"
      "vlc"
      "dbeaver-community"
      "telegram"
      "okta-verify"
      "expressvpn"
      "obsidian"
      "claude-code@latest"
      "docker-desktop"
    ];

    taps = [
      "asmvik/formulae"
    ];

    brews = [
      "asmvik/formulae/yabai"
      "asmvik/formulae/skhd"
    ];
  };

  # Project toolchains and build libraries live in per-project devenv.nix files.
  environment.systemPackages = with pkgs; [
    rsync
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    nerd-fonts.fira-code
  ];

  programs.zsh.enable = true;
  programs.direnv.enable = true;

  # Optional on macOS, but safe to keep.
  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  system.stateVersion = 5;

  # nix.enable = false (Determinate Nix manages nix.conf), so nix.settings is unavailable.
  # Determinate Nix owns nix.conf but never overwrites nix.custom.conf (!include'd by nix.conf).
  # Idempotently add the current user to trusted-users so devenv and flakes work correctly.
  system.activationScripts.nixTrustedUsers.text = ''
    if ! grep -q "trusted-users.*${username}" /etc/nix/nix.custom.conf 2>/dev/null; then
      echo "trusted-users = root ${username}" >> /etc/nix/nix.custom.conf
      launchctl kickstart -k system/systems.determinate.nix-daemon 2>/dev/null || true
    fi
  '';
}
