{
  inputs,
  lib,
  config,
  pkgs,
  ...
}@args: 
let
  enableHyprland = args.enableHyprland or false;
  enableGnome    = args.enableGnome or false;
in {
  imports = [
    ./hardware-configuration.nix
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    OPENSSL_ROOT_DIR = "${pkgs.openssl.dev}";
    USE_HTTPS = "OpenSSL";
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      # Optimize storage
      auto-optimise-store = true;
    };

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will globally add your flake inputs to nix path
    # Allows legacy nix commands to find your flake inputs
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.toSourcePath or value}") inputs;
  };

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-lua
    ];
  };

  services.printing.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.dbus.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
  };

  services.desktopManager.gnome.enable = enableGnome;

  services.displayManager.gdm.enable = true;

  services.displayManager = {
    defaultSession = lib.mkDefault (
      if enableHyprland then "hyprland"
      else "gnome"
    );
  };

  services.gnome = {
    tinysparql.enable = false;
    localsearch.enable = false;
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    jack.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = ["multi-user.target"];

  networking.networkmanager.enable = true;
  networking.hostName = "nixos";
  networking.wireless.iwd.enable = true;

  environment.gnome.excludePackages = lib.mkIf enableGnome (with pkgs; [
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-tour
    epiphany
    totem
    simple-scan
    geary
    yelp
  ]);


  environment.systemPackages = with pkgs; [
    # Build essentials
    pkg-config
    gnumake
    cmake
    openssl.dev
    libxml2
    libxslt
    zlib
    libgit2
    heimdal
    krb5.dev
    gcc
    adwaita-qt
    wl-clipboard
    lact
    sbctl
    lsof

    # Core system utilities
    wsdd
    wget
    curl
    zip
    unzip
    kitty
    ripgrep
    btop
    fastfetch
    awscli
    ngrok

    # Language Managers
    pnpm
    nodejs_24
    (ruby.withPackages (p: [ p.ruby-lsp p.solargraph p.rubocop p.rugged ]))
    go
    python314
    pnpm
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    nerd-fonts.fira-code
  ];

  programs.hyprland = {
    enable = enableHyprland;
    xwayland.enable = true;
  };

  xdg.portal = lib.mkIf enableHyprland {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  programs.zsh = {
    enable = true;
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      input-overlay
      obs-vaapi
      obs-vkcapture
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  virtualisation.docker.enable = true;

  users.defaultUserShell = pkgs.zsh;
  users.users = {
    cesar = {
      initialPassword = "password";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      extraGroups = ["wheel" "networkmanager" "audio" "bluetooth" "docker"];
    };
  };

  system.stateVersion = "25.05";
}
