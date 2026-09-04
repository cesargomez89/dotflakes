{ lib, config, pkgs, inputs, ... }:

{
  # Disabled to avoid conflict with Determinate Nix installer
  nix.enable = false;

  time.timeZone = lib.mkDefault "America/Mexico_City";

  networking.hostName = lib.mkDefault "macbook-pro";
  networking.computerName = lib.mkDefault "MacBook Pro";

  system.primaryUser = "cesar";

  networking.applicationFirewall.allowSignedApp = false;

  system.defaults.NSGlobalDomain = {
    AppleICUForce24HourTime = true;
  };

  services.mac-app-util.enable = true;

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "cesar";
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
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
      "karabiner-elements"
      "okta-verify"
      "expressvpn"
      "obsidian"
      "claude-code@latest"
      "docker"
    ];

    taps = [
      "koekeishiya/formulae"
    ];

    brews = [
      "rbenv"
      "koekeishiya/formulae/yabai"
      "koekeishiya/formulae/skhd"
    ];
  };

  environment.systemPackages = with pkgs; [
    pkg-config
    cmake
    gcc
    openssl.dev
    libxml2
    libxslt
    libyaml
    zlib
    libgit2
    heimdal
    krb5.dev
    gettext
    rsync
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    nerd-fonts.fira-code
  ];

  programs.zsh.enable = true;
  programs.direnv.enable = true;

  # Optional on macOS, but safe to keep.
  users.users.cesar = {
    home = "/Users/cesar";
    shell = pkgs.zsh;
  };

  system.stateVersion = 5;
}
