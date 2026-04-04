{ lib, pkgs, pkgsCuda, ... }:

{
  imports = [
    ../../base.nix
    ../../gnome.nix
    ../../nvidia.nix
    ../../options.nix
    ./hardware-configuration.nix
  ];

  config = {
    enableNvidia = true;

    environment.systemPackages = with pkgs; [
      pkgsCuda.llama-cpp
    ];

    specialisation.on-the-go.configuration = {
      enableNvidiaOffload = lib.mkForce true;
    };
  };
}
