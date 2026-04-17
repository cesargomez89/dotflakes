{ lib, pkgs, pkgsCuda, llama-cpp-nvidia, ... }:

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
  ] ++ [ llama-cpp-nvidia ];

    specialisation.on-the-go.configuration = {
      enableNvidiaOffload = lib.mkForce true;
    };
  };
}
