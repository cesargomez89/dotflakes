{ lib, unstablePkgs, llama-cpp-amd, ... }:

{
  imports = [
    ../../base.nix
    ../../niri.nix
    ../../options.nix
    ./hardware-configuration.nix
  ];

  config = {
    desktopEnv = "niri";

    hardware.graphics = {
      enable = true;
      extraPackages = with unstablePkgs; [
      rocmPackages.clr.icd
      rocmPackages.clr.icd
      rocmPackages.rocm-smi 
      rocmPackages.miopen
      rocmPackages.hipblas
      ];
    };

    environment.systemPackages = [ llama-cpp-amd ];
  };
}
