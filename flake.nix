{
  description = "NixOS + GNOME dotfiles";

  inputs = {
    stylix.url = "github:danth/stylix/release-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };
    llama-cpp = {
      url = "github:ggml-org/llama.cpp";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  outputs = {
    self,
    nixpkgs,
    stylix,
    lanzaboote,
    home-manager,
    antigravity-nix,
    noctalia,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    stdenvHostPlatform = { system = "x86_64-linux"; };


    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    llmAgentsPkgs = inputs.llm-agents.packages.${system};

    unstablePkgs = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    llama-cpp-packages = inputs.llama-cpp.outputs.packages.${system};

    llama-cpp-amd = llama-cpp-packages.rocm.overrideAttrs (oldAttrs: {
      cmakeFlags = [ 
        "-DAMDGPU_TARGETS=gfx1201"
        "-DGGML_HIP=ON"
        "-DGGML_HIP_UMA=OFF"
        "-DGGML_HIP_GRAPHS=ON"
        "-DGGML_NATIVE=ON"
        # "-DGGML_LTO=ON"
        "-DGGML_OPENMP=ON"
        "-DGGML_CUDA_FORCE_MMQ=ON"
        "-DGGML_FLASH_ATTN=ON"
        # "-DGGML_AVX=ON"
        # "-DGGML_AVX2=ON"
        # "-DGGML_AVX_VNNI=ON"
        "-DCMAKE_BUILD_TYPE=Release"
        "-DBUILD_SHARED_LIBS=ON"
        "-DLLAMA_BUILD_TESTS=OFF"
        "-DLLAMA_CURL=OFF"
        "-DLLAMA_BUILD_UI=OFF"
        "-DLLAMA_BUILD_WEBUI=OFF"
      ];
    });

    llama-cpp-nvidia = llama-cpp-packages.cuda.overrideAttrs (oldAttrs: {
      cmakeFlags = [ 
        "-DGGML_CUDA=ON"
        "-DGGML_CUDA_F16=ON"
        "-DCMAKE_CUDA_ARCHITECTURES=120"
        "-DGGML_CUDA_FORCE_CUBLAS=ON"
        "-DGGML_CUDA_FA_ALL_QUANTS=ON"
        "-DCMAKE_BUILD_TYPE=Release"
        "-DGGML_FLASH_ATTN=ON"
      ];
    });

    makeNixosConfiguration = name: configPath: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs unstablePkgs llama-cpp-amd llama-cpp-nvidia;
      };
      modules = [
        inputs.stylix.nixosModules.stylix
        configPath
        lanzaboote.nixosModules.lanzaboote
        home-manager.nixosModules.home-manager
        homeManagerModule
      ];
    };

    homeManagerModule = { config, ... }: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.cesar = import ./home-manager/home.nix;
      home-manager.sharedModules = [ inputs.niri.homeModules.niri ];
      home-manager.extraSpecialArgs = {
        inherit inputs stylix unstablePkgs antigravity-nix llama-cpp-amd llama-cpp-nvidia llmAgentsPkgs;
        desktopEnv = config.desktopEnv;
      };
    };
  in {
    nixosConfigurations = {
      desktop-amd = makeNixosConfiguration "desktop-amd" ./nixos/machines/desktop-amd/configuration.nix;
      laptop-nvidia = makeNixosConfiguration "laptop-nvidia" ./nixos/machines/laptop-nvidia/configuration.nix;
      desktop-amd-niri = makeNixosConfiguration "desktop-amd-niri" ./nixos/machines/desktop-amd-niri/configuration.nix;
      laptop-nvidia-niri = makeNixosConfiguration "laptop-nvidia-niri" ./nixos/machines/laptop-nvidia-niri/configuration.nix;
    };
  };
}
