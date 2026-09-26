{
  pkgs,
  lib,
  username,
  ...
}:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in

{
  imports = [
    ./apps.nix
    ./themes.nix
    ./gnome.nix
    ./random-bg.nix
    ./macos.nix
  ];

  home = {
    inherit username;
    homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
    stateVersion = "26.05";

    sessionPath = [ "$HOME/.local/bin" ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    }
    // lib.optionalAttrs (!isDarwin) {
      BROWSER = "google-chrome-stable";
      NIXOS_OZONE_WL = "1";
      XDG_SESSION_TYPE = "wayland";
    };
  };

  programs.home-manager.enable = true;
  dconf.enable = !isDarwin;

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
