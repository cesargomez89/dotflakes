{ pkgs, lib, llmAgentsPkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
in

{
  home.packages =
    (with pkgs; [
      neovim
      starship
      luarocks
      tmux
      lazygit
      lazydocker
      git-lfs
      eza
      obsidian
    ])

    # Linux-only packages
    ++ lib.optionals (!isDarwin) (with pkgs; [
      dbeaver-bin
      pinta
      google-chrome
      zoom-us
      postman
      slack
      telegram-desktop
      pear-desktop
      vlc
      cava
      fum
      open-webui

      nautilus
      papirus-icon-theme
      bibata-cursors
      swww
    ])

    ++ (with pkgs; [
      feishin
    ])

    ++ (with llmAgentsPkgs; [
      claude-code
      opencode
      pi
    ]);
}
