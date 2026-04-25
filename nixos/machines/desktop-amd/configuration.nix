{ lib, pkgs, unstablePkgs, llama-cpp-amd, ... }:

{
  imports = [
    ../../base.nix
    ../../gnome.nix
    ../../options.nix
    ./hardware-configuration.nix
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with unstablePkgs; [
      rocmPackages.clr.icd
      rocmPackages.rocm-smi 
      rocmPackages.miopen
      rocmPackages.hipblas
    ];
  };

  environment.systemPackages = with pkgs; [
    amdgpu_top
    nvtopPackages.amd
  ] ++ [ llama-cpp-amd ];

  desktopEnv = "gnome";
}
