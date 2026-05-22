{ pkgs, unstablePkgs, antigravity-nix, llmAgentsPkgs, ... }:

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
    open-webui
    obsidian
  ]) ++ (with unstablePkgs; [
    feishin
  ]) ++ (with llmAgentsPkgs; [
    claude-code
    opencode
    pi
  ]);
}
