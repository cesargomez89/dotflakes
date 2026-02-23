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
  };

  outputs = {
    self,
    nixpkgs,
    stylix,
    lanzaboote,
    home-manager,
    antigravity-nix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    stdenvHostPlatform = { system = "x86_64-linux"; };

    pkgs = nixpkgs.legacyPackages.${system};

    unstablePkgs = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    enableGnome = true;

    makeNixosConfiguration = name: configPath: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs enableGnome unstablePkgs;
      };
      modules = [
        inputs.stylix.nixosModules.stylix
        configPath
        lanzaboote.nixosModules.lanzaboote
        home-manager.nixosModules.home-manager
        homeManagerModule
      ];
    };

    homeManagerModule = {
      nixpkgs = {
        overlays = [
          (final: prev: {
            unstable = import inputs.nixpkgs-unstable {
              inherit (prev) system;
              config.allowUnfree = true;
            };
          })
        ];
        config.allowUnfree = true;
      };
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.cesar = import ./home-manager/home.nix;
      home-manager.extraSpecialArgs = {
        inherit inputs stylix enableGnome unstablePkgs antigravity-nix;
      };
    };
  in {
    nixosConfigurations = {
      desktop-amd = makeNixosConfiguration "desktop-amd" ./nixos/machines/desktop-amd/configuration.nix;
      laptop-nvidia = makeNixosConfiguration "laptop-nvidia" ./nixos/machines/laptop-nvidia/configuration.nix;
    };
  };
}
