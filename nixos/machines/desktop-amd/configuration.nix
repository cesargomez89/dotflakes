{ lib, pkgs, pkgsRocm, llama-cpp-amd, ... }:

{
  imports = [
    ../../base.nix
    ../../gnome.nix
    ../../options.nix
    ./hardware-configuration.nix
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  environment.systemPackages = with pkgs; [
    amdgpu_top
    nvtopPackages.amd
  ] ++ [ llama-cpp-amd ];

  desktopEnv = "gnome";
}
