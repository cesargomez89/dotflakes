{
  pkgs,
  inputs,
  ...
}:

let
  llama-cpp-vulkan =
    inputs.llama-cpp.packages.${pkgs.stdenv.hostPlatform.system}.vulkan.overrideAttrs
      (old: {
        # Appended so upstream flags are kept; later -D flags win in CMake.
        cmakeFlags = (old.cmakeFlags or [ ]) ++ [
          "-DGGML_VULKAN=ON"
          "-DGGML_NATIVE=ON"
          "-DGGML_OPENMP=ON"
          "-DGGML_FLASH_ATTN=ON"
          "-DGGML_FMA=ON"
          "-DGGML_F16C=ON"
          "-DGGML_LTO=ON"
          "-DCMAKE_BUILD_TYPE=Release"
          "-DBUILD_SHARED_LIBS=ON"
          "-DLLAMA_BUILD_TESTS=OFF"
          "-DLLAMA_CURL=OFF"
          "-DLLAMA_BUILD_UI=OFF"
          "-DLLAMA_BUILD_WEBUI=OFF"
          "-DGGML_CCACHE=OFF"
        ];
      });
in

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

  environment.systemPackages =
    with pkgs;
    [
      amdgpu_top
      nvtopPackages.amd
      vulkan-tools
    ]
    ++ [ llama-cpp-vulkan ];

  desktopEnv = "gnome";
}
