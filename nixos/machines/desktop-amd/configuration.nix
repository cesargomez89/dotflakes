{
  pkgs,
  ...
}:

{
  imports = [
    ../../base.nix
    ../../gnome.nix
    ../../options.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "desktop-amd";

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      rocmPackages.rocm-smi
      rocmPackages.miopen
      rocmPackages.hipblas
    ];
  };

  environment.systemPackages = with pkgs; [
    amdgpu_top
    nvtopPackages.amd
    vulkan-tools
    llama-cpp-vulkan
  ];

  desktopEnv = "gnome";
}
