{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
    };
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "en_US.UTF-8";

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.displayManager.defaultSession = "hyprland";

  
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  networking.networkmanager.enable = true;
  networking.hostName = "nixos";

  environment.systemPackages = with pkgs; [
    gcc
    go
    gnumake
    wl-clipboard
    python314
    swaynotificationcenter
    zsh
    kitty
    neovim
    luarocks
    starship
    eza
    wget
    btop
    neofetch
    cava
    google-chrome
    slack
    postman
    zoom
    dbeaver-bin
    telegram-desktop
    aider-chat
  ];

  programs.zsh.enable = true;
  programs.light.enable = true;
  programs.light.brightnessKeys.enable = true;
  programs.thunar.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  virtualisation.docker.enable = true;

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaCode" "FiraCode" ]; })
  ];

  stylix.enable = true;
  stylix.polarity = "dark";
  stylix.image = ./dandadan.png;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  stylix.opacity = {
    desktop = 0.2;
  };

  users.defaultUserShell = pkgs.zsh;
  users.users = {
    cesar = {
      initialPassword = "password";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      extraGroups = ["wheel" "networkmanager" "docker"];
    };
  };

  system.stateVersion = "24.11";
}
