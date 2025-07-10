{ config, pkgs, lib, ... }:

{
  home.username = "cesar";
  home.homeDirectory = "/home/cesar";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  dconf.enable = true;

  home.packages = with pkgs; [
    # GUI Applications
    gnome-tweaks
    dconf-editor
    gparted
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
    aider-chat

    # GNOME Extensions
    gnomeExtensions.open-bar
    gnomeExtensions.media-controls
    gnomeExtensions.vitals
    gnomeExtensions.user-themes
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.tiling-shell

    # Icons and Themes
    papirus-icon-theme
  ];

  imports = [
    ./random-bg.nix
    ./dconf.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "google-chrome-stable";
    GEM_HOME = "$HOME/.local/share/gem/ruby/3.4.0";
    GEM_PATH = "$HOME/.local/share/gem/ruby/3.4.0";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.local/share/gem/ruby/3.4.0/bin"
  ];

  programs.git = {
    enable = true;
    extraConfig = {
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
