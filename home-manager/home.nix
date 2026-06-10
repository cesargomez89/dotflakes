{ config, pkgs, lib, stylix, desktopEnv, llmAgentsPkgs, ... }@args:

let
  isGnome = desktopEnv == "gnome";
  isDarwin = desktopEnv == "darwin";
in

{
  imports = [
    ./apps.nix
    ./themes.nix
  ] ++ lib.optionals isGnome [
    ./gnome.nix
    ./random-bg.nix
  ] ++ lib.optionals isDarwin [
    ./macos.nix
  ];

  home.username = "cesar";
  home.homeDirectory = if isDarwin then "/Users/cesar" else "/home/cesar";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
  dconf.enable = !isDarwin;

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "google-chrome-stable";
  } // lib.optionalAttrs (!isDarwin) {
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
  };

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.obs-studio = lib.mkIf (!isDarwin) {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      input-overlay
      obs-vaapi
      obs-vkcapture
    ];
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
    pinentry.package = if isDarwin then pkgs.pinentry_mac else pkgs.pinentry-gnome3;
  };
}
