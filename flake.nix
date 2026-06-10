{
  description = "NixOS + macOS dotfiles";

  inputs = {
    stylix.url = "github:danth/stylix/release-26.05";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents.url = "github:numtide/llm-agents.nix";

    llama-cpp = {
      url = "github:ggml-org/llama.cpp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    {
      self,
      nixpkgs,
      stylix,
      lanzaboote,
      home-manager,
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

      darwinPkgs = import nixpkgs {
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

      homeManagerModule =
        { config, ... }:
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.cesar =
            import ./home-manager/home.nix;

          home-manager.extraSpecialArgs = {
            inherit
              inputs
              stylix
              llama-cpp-vulkan
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
              llama-cpp-vulkan;
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
      };

      darwinConfigurations = {
        macbook-pro =
          makeDarwinConfiguration
            ./darwin/machines/macbook-pro/configuration.nix;
      };
    };
}
