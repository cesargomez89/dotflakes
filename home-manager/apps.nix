{ pkgs, lib, unstablePkgs, antigravity-nix, llmAgentsPkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  antigravity = antigravity-nix.packages.${pkgs.system}.default or antigravity-nix.packages.x86_64-linux.default;
in

{
  home.packages = (with pkgs; [
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
    open-webui
    obsidian
  ] ++ lib.optionals (!isDarwin) [
    nautilus
    papirus-icon-theme
    bibata-cursors
    swww
    antigravity
  ] ++ lib.optionals isDarwin [
    antigravity
  ]) ++ (with unstablePkgs; [
    feishin
  ]) ++ (with llmAgentsPkgs; [
    claude-code
    opencode
    pi
  ]);
}
