{ config, pkgs, lib, stylix, antigravity-nix, ... }@args:

let
  enableGnome = args.enableGnome or false;
in

{
  imports = [
    ./apps.nix
    ./themes.nix
  ] ++ lib.optionals enableGnome [
    ./gnome.nix
    ./random-bg.nix
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
