{ config, pkgs, stylix, lib, antigravity-nix, ... }@args:
let
  enableGnome = args.enableGnome or false;
in
{
  home.username = "cesar";
  home.homeDirectory = "/home/cesar";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
  dconf.enable = true;

  home.packages = with pkgs; [
    # GUI Applications
    dbeaver-bin
    pinta
    google-chrome
    zoom-us
    postman
    slack
    telegram-desktop
    youtube-music
    vlc

    # User-space Dev Tools
    neovim
    starship
    luarocks
    tmux
    lazygit
    lazydocker
    eza
    cava
    fum
    unstable.opencode
    unstable.feishin
    antigravity-nix.packages.x86_64-linux.default

    # Icons and Themes
    papirus-icon-theme
    bibata-cursors
  ];

  imports = [
    stylix.homeModules.stylix
    ./random-bg.nix
  ] ++ lib.optionals enableGnome [
    ./gnome.nix
  ];

  stylix.enable = true;
  stylix.targets.qt.platform = lib.mkForce "qtct";
  stylix.targets.gtk.enable = true;
  stylix.targets.qt.enable = true;
  stylix.polarity = "dark";

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  stylix.opacity = {
    desktop = 0.2;
  };

  stylix.icons = {
    enable = true;
    package = pkgs.papirus-icon-theme;
    dark = "Papirus-Dark";
    light = "Papirus";
  };

  stylix.cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "google-chrome-stable";
  };

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };
}
