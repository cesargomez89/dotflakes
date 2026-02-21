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
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
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

  boot.kernelPackages = pkgs.linuxPackages_latest;
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
    videoDrivers = [ "modesetting" "nvidia" ];
  };

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    open = true;
    modesetting.enable = true;
    nvidiaSettings = true;

    # CRITICAL: prevent PCIe root + USB from sleeping
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  specialisation.on-the-go.configuration = {
    system.nixos.tags = [ "on-the-go" ];
    boot.kernelParams = [ "nvidia.NVreg_DynamicPowerManagement=0x02" ];
    services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];

    hardware.nvidia = {
      powerManagement.finegrained = lib.mkForce true;
      prime = {
        offload = {
          enable = lib.mkForce true;
          enableOffloadCmd = lib.mkForce true;
        };
        sync.enable = lib.mkForce false;
      };
    };
  };

  services.displayManager = {
    gdm.enable = true;
    defaultSession = lib.mkDefault (
      if enableHyprland then "hyprland"
      else "gnome"
    );
  };

  services.gnome = {
    tinysparql.enable = false;
    localsearch.enable = false;
  };

  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      RUNTIME_PM_ON_AC = "on";
      PCIE_ASPM_ON_AC = "default";
      CPU_BOOST_ON_AC = 1;
      USB_AUTOSUSPEND_ON_AC = 0;

      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      RUNTIME_PM_ON_BAT = "on";
      PCIE_ASPM_ON_BAT = "default";
      CPU_BOOST_ON_BAT = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;

      USB_AUTOSUSPEND = 0;

      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 85;
    };
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

  services.gnome = {
    core-developer-tools.enable = true; # ensures proper runtime env
  };

  environment.sessionVariables = {
    GST_PLUGIN_SYSTEM_PATH_1_0 =
      "${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0:" +
      "${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0:" +
      "${pkgs.gst_all_1.gst-plugins-bad}/lib/gstreamer-1.0:" +
      "${pkgs.gst_all_1.gst-plugins-ugly}/lib/gstreamer-1.0:" +
      "${pkgs.gst_all_1.gst-libav}/lib/gstreamer-1.0";
  };

  environment.systemPackages = with pkgs; [
    pkg-config gnumake cmake openssl.dev libxml2 libxslt libyaml zlib libgit2 heimdal krb5.dev gcc
    adwaita-qt wl-clipboard lact sbctl lsof
    wsdd wget curl zip unzip kitty ripgrep btop fastfetch awscli ngrok powertop sqlite
    pnpm nodejs_24 (ruby.withPackages (p: [ p.ruby-lsp p.solargraph p.rubocop p.rugged ]))
    go golangci-lint python314 pnpm
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
      initialPassword = "password";
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
