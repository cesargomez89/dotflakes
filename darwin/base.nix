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
      autoUpdate = true;
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

    brews = [
      "rbenv"
      "fnm"
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

    lsof
    wget
    curl
    zip
    unzip
    btop
    fastfetch

    ripgrep
    fd
    jq
    yq
    ast-grep
    difftastic
    shellcheck
    just
    gh
    parallel
    tmux
    sqlite
    sd
    entr
    hyperfine

    awscli2
    ngrok
    sqlite

    bun
    go
    golangci-lint
    python3

    gettext
    rsync

    kubectl
    kustomize

    stylua
    lua-language-server
    ffmpeg
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
