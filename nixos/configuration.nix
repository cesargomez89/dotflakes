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

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      nix-path = config.nix.nixPath;
    };

    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
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
  i18n.inputMethod.enabled = null;

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
    desktopManager.gnome.enable = enableGnome;
    displayManager.gdm.enable = true;
    videoDrivers = [ "amdgpu" ];
  };

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

  nixpkgs = {
    overlays = [
      (final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (prev) system;
          config = prev.config;
        };
      })
    ];
    config = {
      allowUnfree = true;
    };
  };

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
    shellInit = ''
      export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig"
      export OPENSSL_ROOT_DIR="${pkgs.openssl.dev}"
      export USE_HTTPS="OpenSSL"
    '';
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
