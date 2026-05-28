{
  description = "NixOS + macOS dotfiles";

  inputs = {
    stylix.url = "github:danth/stylix/master";

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
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

    llm-agents.url = "github:numtide/llm-agents.nix";

    llama-cpp = {
      url = "github:ggml-org/llama.cpp";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    mac-app-util.url = "github:hraban/mac-app-util";
  };

  nixConfig = {
    extra-substituters = [
      "https://noctalia.cachix.org"
    ];

    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      stylix,
      lanzaboote,
      home-manager,
      noctalia,
      nix-darwin,
      nix-homebrew,
      mac-app-util,
      ...
    }@inputs:

    let
      linuxSystem = "x86_64-linux";
      darwinSystem = "aarch64-darwin";

      pkgs = import nixpkgs {
        system = linuxSystem;
        config.allowUnfree = true;
      };

      unstablePkgs = import inputs.nixpkgs-unstable {
        system = linuxSystem;
        config.allowUnfree = true;
      };

      darwinPkgs = import nixpkgs {
        system = darwinSystem;
        config.allowUnfree = true;
      };

      unstableDarwinPkgs = import inputs.nixpkgs-unstable {
        system = darwinSystem;
        config.allowUnfree = true;
      };

      llmAgentsPkgs =
        inputs.llm-agents.packages.${linuxSystem};

      llmAgentsDarwinPkgs =
        inputs.llm-agents.packages.${darwinSystem};

      llama-cpp-packages =
        inputs.llama-cpp.packages.${linuxSystem};

      llama-cpp-vulkan =
        llama-cpp-packages.vulkan.overrideAttrs (_: {
          cmakeFlags = [
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

      llama-cpp-nvidia =
        llama-cpp-packages.cuda.overrideAttrs (_: {
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

      homeManagerModule =
        { config, ... }:
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.cesar =
            import ./home-manager/home.nix;

          home-manager.sharedModules = [
            inputs.niri.homeModules.niri
          ];

          home-manager.extraSpecialArgs = {
            inherit
              inputs
              stylix
              unstablePkgs
              llama-cpp-vulkan
              llama-cpp-nvidia
              llmAgentsPkgs;

            desktopEnv = config.desktopEnv;
          };
        };

      homeManagerDarwinModule =
        { ... }:
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.cesar =
            import ./home-manager/home.nix;

          home-manager.extraSpecialArgs = {
            inherit
              inputs
              stylix;

            unstablePkgs = unstableDarwinPkgs;
            llmAgentsPkgs = llmAgentsDarwinPkgs;

            desktopEnv = "darwin";
          };
        };

      makeNixosConfiguration =
        configPath:
        nixpkgs.lib.nixosSystem {
          system = linuxSystem;

          specialArgs = {
            inherit
              inputs
              unstablePkgs
              llama-cpp-vulkan
              llama-cpp-nvidia;
          };

          modules = [
            stylix.nixosModules.stylix
            lanzaboote.nixosModules.lanzaboote
            home-manager.nixosModules.home-manager
            homeManagerModule
            configPath
          ];
        };

      makeDarwinConfiguration =
        configPath:
        nix-darwin.lib.darwinSystem {
          system = darwinSystem;

          specialArgs = {
            inherit
              inputs;

            unstablePkgs = unstableDarwinPkgs;
            llmAgentsPkgs = llmAgentsDarwinPkgs;
          };

          modules = [
            {
              nixpkgs.config.allowUnfree = true;
            }

            stylix.darwinModules.stylix
            nix-homebrew.darwinModules.nix-homebrew
            mac-app-util.darwinModules.default

            home-manager.darwinModules.home-manager
            homeManagerDarwinModule

            configPath
          ];
        };

    in
    {
      nixosConfigurations = {
        desktop-amd =
          makeNixosConfiguration
            ./nixos/machines/desktop-amd/configuration.nix;

        laptop-nvidia =
          makeNixosConfiguration
            ./nixos/machines/laptop-nvidia/configuration.nix;

        desktop-amd-niri =
          makeNixosConfiguration
            ./nixos/machines/desktop-amd-niri/configuration.nix;

        laptop-nvidia-niri =
          makeNixosConfiguration
            ./nixos/machines/laptop-nvidia-niri/configuration.nix;
      };

      darwinConfigurations = {
        macbook-pro =
          makeDarwinConfiguration
            ./darwin/machines/macbook-pro/configuration.nix;
      };
    };
}
