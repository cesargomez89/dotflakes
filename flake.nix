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
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
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
    claude-code,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    stdenvHostPlatform = { system = "x86_64-linux"; };


    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    unstablePkgs = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
      overlays = [ claude-code.overlays.default ];
    };

    pkgsCuda = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
      config.cudaSupport = true;
      config.cudaCapabilities = [ "10.0" ];
    };

    pkgsRocm = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
      config.rocmSupport = true;
    };

    llama-cpp-packages = inputs.llama-cpp.outputs.packages.${system};

    llama-cpp-amd = llama-cpp-packages.rocm.overrideAttrs (oldAttrs: {
      cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [ 
        "-DGGML_HIP=ON"
        "-DAMDGPU_TARGETS=gfx1201" 
        "-DGGML_HIP_UMA=OFF"
      ];
    });

    llama-cpp-nvidia = llama-cpp-packages.cuda.overrideAttrs (oldAttrs: {
      cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [ 
        "-DGGML_CUDA=ON"
        "-DGGML_CUDA_F16=ON"
        "-DCMAKE_CUDA_ARCHITECTURES=100"
      ];
    });


    makeNixosConfiguration = name: configPath: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs unstablePkgs pkgsCuda pkgsRocm llama-cpp-amd llama-cpp-nvidia;
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
        inherit inputs stylix unstablePkgs antigravity-nix llama-cpp-amd llama-cpp-nvidia;
        desktopEnv = config.desktopEnv;
        pkgsWithClaude = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ claude-code.overlays.default ];
        };
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
