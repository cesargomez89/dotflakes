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
    llama-cpp = {
      url = "github:ggml-org/llama.cpp";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
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

    pkgs = nixpkgs.legacyPackages.${system};

    unstablePkgs = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
      overlays = [ inputs.llama-cpp.overlays.default claude-code.overlays.default ];
    };

    pkgsCuda = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
      config.cudaSupport = true;
      overlays = [ inputs.llama-cpp.overlays.default ];
    };

    pkgsRocm = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
      config.rocmSupport = true;
      overlays = [ inputs.llama-cpp.overlays.default ];
    };


    makeNixosConfiguration = name: configPath: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs unstablePkgs pkgsCuda pkgsRocm;
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
        inherit inputs stylix unstablePkgs antigravity-nix;
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
