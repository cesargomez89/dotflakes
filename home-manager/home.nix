{ config, pkgs, lib, stylix, unstablePkgs, antigravity-nix, desktopEnv, ... }@args:

let
  isGnome = desktopEnv == "gnome";
in

{
  imports = [
    ./apps.nix
    ./themes.nix
  ] ++ lib.optionals isGnome [
    ./gnome.nix
    ./random-bg.nix
  ] ++ lib.optionals (desktopEnv == "niri") [
    ./niri.nix
  ];

  home.username = "cesar";
  home.homeDirectory = "/home/cesar";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
  dconf.enable = true;

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
