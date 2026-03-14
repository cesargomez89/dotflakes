{ pkgs, antigravity-nix, ... }:

{
  home.packages = with pkgs; [
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
    unstable.opencode
    unstable.feishin
    antigravity-nix.packages.x86_64-linux.default
    papirus-icon-theme
    bibata-cursors
  ];

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
