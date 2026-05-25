{ lib, config, pkgs, inputs, ... }:

{
  nix.settings = {
    experimental-features = "nix-command flakes";
    flake-registry = "";
    auto-optimise-store = true;
  };

  nix.registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
  nix.nixPath = lib.mapAttrsToList (key: value: "${key}=${value.toSourcePath or value}") inputs;

  time.timeZone = lib.mkDefault "America/Mexico_City";

  system.defaults.NSGlobalDomain.AppleICUForce24HourTime = true;

  networking.hostName = lib.mkDefault "macbook-pro";
  networking.computerName = lib.mkDefault "MacBook Pro";

  system.defaults.alf.allowdownloadsignedenabled = false;

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "cesar";
    autoMigrate = true;
  };

  environment.systemPackages = with pkgs; [
    pkg-config cmake gcc openssl.dev libxml2 libxslt libyaml zlib libgit2 heimdal krb5.dev
    lsof wget curl zip unzip ripgrep btop fastfetch gh jq
    kitty
    awscli2 ngrok sqlite
    pnpm bun nodejs_24
    go golangci-lint python3
    gettext rsync kubectl kustomize stylua lua-language-server
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    nerd-fonts.fira-code
  ];

  programs.zsh.enable = true;
  programs.direnv.enable = true;

  users.users.cesar = {
    name = "cesar";
    home = "/Users/cesar";
    shell = pkgs.zsh;
  };

  system.stateVersion = 5;
}
