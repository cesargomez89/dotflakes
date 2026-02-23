{
  inputs,
  lib,
  config,
  pkgs,
  enableGnome,
  ...
}:

{
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
      auto-optimise-store = true;
    };

    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.toSourcePath or value}") inputs;
  };

  boot.kernelPackages = pkgs.linuxPackages;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;

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

  services.desktopManager.gnome.enable = enableGnome;

  services.xserver = {
    enable = true;
    videoDrivers = [ "modesetting" ];
  };

  services.displayManager = {
    gdm.enable = true;
    defaultSession = lib.mkDefault "gnome";
  };

  services.gnome = {
    tinysparql.enable = false;
    localsearch.enable = false;
    core-developer-tools.enable = true;
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
    pkg-config gnumake cmake openssl.dev libxml2 libxslt libyaml zlib libgit2 heimdal krb5.dev gcc
    adwaita-qt wl-clipboard lact sbctl lsof
    wsdd wget curl zip unzip kitty ripgrep btop fastfetch awscli ngrok sqlite
    pnpm nodejs_24 (ruby.withPackages (p: [ p.ruby-lsp p.solargraph p.rubocop p.rugged ]))
    go golangci-lint python314
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    nerd-fonts.fira-code
  ];

  programs.zsh.enable = true;

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
      isNormalUser = true;
      openssh.authorizedKeys.keys = [];
      extraGroups = ["wheel" "networkmanager" "audio" "bluetooth" "docker"];
    };
  };

  fileSystems."/mnt/nas" = {
    device = "//192.168.31.250/Storage";
    fsType = "cifs";
    options = [
      "credentials=/etc/nixos/secrets/nas-smb"
      "x-systemd.automount"
      "noatime"
      "rw"
      "vers=3.1.1"
      "serverino"
      "uid=1000"
      "gid=1000"
      "file_mode=0775"
      "dir_mode=0775"
      "soft"
      "_netdev"
    ];
  };

  system.stateVersion = "25.11";
}
