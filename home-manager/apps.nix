{ pkgs, unstablePkgs, antigravity-nix, ... }:

{
  home.packages = (with pkgs; [
    nautilus
    dbeaver-bin
    pinta
    google-chrome
    zoom-us
    postman
    slack
    telegram-desktop
    youtube-music
    vlc
    neovim
    starship
    luarocks
    tmux
    lazygit
    lazydocker
    eza
    cava
    fum
    papirus-icon-theme
    bibata-cursors
    swww
    antigravity-nix.packages.x86_64-linux.default
  ]) ++ (with unstablePkgs; [
    opencode
    feishin
  ]);

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      input-overlay
      obs-vaapi
      obs-vkcapture
    ];
  };
}
