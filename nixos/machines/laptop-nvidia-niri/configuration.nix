{ lib, pkgs, pkgsCuda, llama-cpp-nvidia, ... }:

{
  imports = [
    ../../base.nix
    ../../niri.nix
    ../../nvidia.nix
    ../../options.nix
    ./hardware-configuration.nix
  ];

  config = {
    desktopEnv = "niri";
    enableNvidia = true;

    environment.systemPackages = with pkgs; [
  ] ++ [ llama-cpp-nvidia ];

    specialisation.on-the-go.configuration = {
      enableNvidiaOffload = lib.mkForce true;
    };
  };
}
